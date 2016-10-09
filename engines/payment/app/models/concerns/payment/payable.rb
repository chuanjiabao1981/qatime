module Payment
  module Payable
    extend ActiveSupport::Concern
    included do
      has_one :remote_order, as: :order
      after_save :instance_remote_order, if: :pay_type_changed?
    end

    # 第三方订单subject
    def subject
    end

    protected

    def instance_remote_order
      if pay_type.weixin?
        create_remote_order!(amount: amount, remote_ip: remote_ip, order_no: transaction_no, type: 'Payment::WeixinOrder', trade_type: Payment::WeixinOrder::TRADE_TYPES[source.to_sym])
      elsif pay_type.alipay?
        create_remote_order!(amount: amount, remote_ip: remote_ip, order_no: transaction_no, type: 'Payment::AlipayOrder')
      end
    end
  end
end
