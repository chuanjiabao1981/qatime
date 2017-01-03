module Payment
  class WeixinRefund < RemoteOrder
    belongs_to :refund
    RESULT_SUCCESS = "SUCCESS".freeze

    def remote_transfer
      return fail! if Rails.env.test?
      r = WxPay::Service.invoke_refund(refund_remote_params)
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
        total_fee: refund.order.pay_money,
        refund_fee: pay_money,
        op_user_id: WxPay.mch_id,
        desc: "用户提现"
      }
    end

    def pay_money
      money = super
      (money * 100).to_i
    end
  end
end
