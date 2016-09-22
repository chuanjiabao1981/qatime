module Payment
  module Payable
    extend ActiveSupport::Concern
    included do
      has_one :remote_order, as: :order, class_name: Payment::WeixinOrder
      after_save :instance_remote_order, if: :pay_type_changed?
    end

    protected
    def instance_remote_order
      return unless pay_type.weixin?
      create_remote_order(amount: amount, remote_ip: remote_ip, order_no: transaction_no, trade_type: Payment::WeixinOrder::TRADE_TYPES[source.to_sym])
    end
  end
end
