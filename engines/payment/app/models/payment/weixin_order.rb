module Payment
  class WeixinOrder < RemoteOrder
    RESULT_SUCCESS = "SUCCESS".freeze

    TRADE_TYPES = {
      web: "NATIVE",
      app: "APP"
    }.freeze

    has_one :qr_code, as: :qr_codeable

    def payment_url(size = nil)
      # APP支付不需要支付地址
      return unless trade_type == TRADE_TYPES[:web]
      instance_qr_code unless qr_code
      qr_code.code_url(size)
    end

    private
    after_create :remote_sync
    def remote_sync
      return if Rails.env.test?
      r = WxPay::Service.invoke_unifiedorder(remote_params)
      remote_result(r)
    end

    def remote_params
      {
        body: "账户充值",
        out_trade_no: order_no,
        total_fee: pay_money,
        spbill_create_ip: remote_ip,
        notify_url: notify_url,
        trade_type: trade_type,
        fee_type: 'CNY'
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

  end
end
