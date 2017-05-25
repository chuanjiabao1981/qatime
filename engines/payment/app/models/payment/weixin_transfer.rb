module Payment
  class WeixinTransfer < RemoteOrder
    RESULT_SUCCESS = "SUCCESS".freeze

    def remote_transfer
      # 根据订单来源设置企业支付证书
      # 可能会有并发问题
      WxPay.set_apiclient_by_pkcs12(*WechatSetting[:app_cert])
      return fail! if Rails.env.test?
      r = WxPay::Service.invoke_transfer(transfer_remote_params)
      self.hold_results = JSON.parse(r.to_json)
      self.hold_remotes = transfer_remote_params
      r['return_code'] == RESULT_SUCCESS && r['result_code'] == RESULT_SUCCESS ? pay! : fail!
    end

    private

    # 企业支付参数
    def transfer_remote_params
      {
        partner_trade_no: order_no,
        amount: pay_money,
        spbill_create_ip: remote_ip,
        check_name: 'NO_CHECK',
        openid: order.withdraw_record.account,
        desc: "用户提现"
      }
    end

    def pay_money
      (amount * 100).to_i
    end
  end
end
