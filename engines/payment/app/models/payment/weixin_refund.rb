module Payment
  class WeixinRefund < RemoteOrder
    belongs_to :order, polymorphic: true
    RESULT_SUCCESS = "SUCCESS".freeze

    def remote_refund
      return if Rails.env.test?
      # 根据订单来源设置退款证书
      # 可能会有并发问题
      WxPay.set_apiclient_by_pkcs12(*WechatSetting["#{order.source}_cert".to_sym])
      r = WxPay::Service.invoke_refund(refund_remote_params, weixin_options)
      self.hold_results = JSON.parse(r.to_json)
      self.hold_remotes = refund_remote_params
      r['return_code'] == RESULT_SUCCESS && r['result_code'] == RESULT_SUCCESS ? pay! : fail!
    end

    private

    # 退款参数
    def refund_remote_params
      {
        out_trade_no: order_no,
        out_refund_no: order_no,
        total_fee: order.order.pay_money,
        refund_fee: pay_money,
        op_user_id: WxPay.mch_id
      }
    end

    def pay_money
      money = super
      (money * 100).to_i
    end

    def weixin_options
      ::WechatSetting[order.source.to_sym].dup
    end
  end
end
