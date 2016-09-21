module Payment
  module AutoPayable
    extend ActiveSupport::Concern
    included do
      has_one :remote_order, as: :order, class_name: Payment::WeixinOrder
      after_create :auto_paid!
    end

    protected

    def auto_paid!
    end
  end
end
