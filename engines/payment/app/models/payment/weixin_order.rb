module Payment
  class WeixinOrder < RemoteOrder
    RESULT_SUCCESS = "SUCCESS".freeze

    TRADE_TYPES = {
      web: "NATIVE",
      app: "APP",
      wap: "JSAPI"
    }.freeze

    has_one :qr_code, as: :qr_codeable

    def proccess_notify(result)
      return unless unpaid?
      check_result(result)
      self.pay_at = result['time_end']
      result["result_code"] == RESULT_SUCCESS ? pay! : fail!
    end

    def payment_url(size = nil)
      # APP支付不需要支付地址
      return unless trade_type == TRADE_TYPES[:web]
      instance_qr_code unless qr_code
      qr_code.code_url(size)
    end

    def app_pay_params
      WxPay::Service.generate_app_pay_req(prepayid: prepay_id, noncestr: nonce_str)
    end

    private
    after_create :remote_sync
    def remote_sync
      return if Rails.env.test? || order.created_at < 3.hours.ago
      r = WxPay::Service.invoke_unifiedorder(remote_params)
      remote_result(r)
    end

    # 用户支付参数
    def remote_params
      {
        body: order.subject,
        out_trade_no: order_no,
        total_fee: pay_money,
        spbill_create_ip: remote_ip,
        notify_url: order.notify_url,
        trade_type: trade_type,
        fee_type: 'CNY'
      }
    end

    # 企业支付参数
    def transfer_remote_params
      {
        partner_trade_no: order_no,
        amount: pay_money,
        spbill_create_ip: remote_ip,
        check_name: 'NO_CHECK',
        openid: order.try(:user).try(:wechat_users).try(:last).try(:openid),
        desc: "用户提现"
      }
    end

    def pay_money
      money = super
      (money * 100).to_i
    end

    def remote_result(r)
      return log_error(r) unless r["return_code"] == Payment::WeixinOrder::RESULT_SUCCESS
      assign_attributes(pay_url: r['code_url'], prepay_id: r['prepay_id'], nonce_str: r['nonce_str'])
      save
    end

    def instance_qr_code
      if Rails.env.test? && pay_url.blank?
        self.pay_url = "http://localhost"
        save
      end
      return if pay_url.blank?
      relative_path = QrCode.generate_tmp(pay_url)
      tmp_path = Rails.root.join(relative_path)
      File.open(tmp_path) do |file|
        create_qr_code(code: file)
      end
      File.delete(tmp_path)
    end

    def log_error(r)
      logger.error '===== PAYMENT ERROR START ====='
      logger.error r
      logger.error remote_params
      logger.error '===== PAYMENT ERROR END ====='
      fail!
    end

    def check_result(result)
      raise Payment::InvalidNotify, '通知签名不正确' unless WxPay::Sign.verify?(result)
      raise Payment::IncorrectAmount, '金额不正确' unless result['total_fee'].to_f == pay_money.to_f
      raise Payment::InvalidNotify, '非法通知' unless result["appid"] == WxPay.appid.to_s
      raise Payment::InvalidNotify, '非法通知' unless result["mch_id"] == WxPay.mch_id.to_s
    end
  end
end
