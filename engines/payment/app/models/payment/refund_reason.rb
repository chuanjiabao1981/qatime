module Payment
  class RefundReason < ActiveRecord::Base
    belongs_to :refund_apply
  end
end
