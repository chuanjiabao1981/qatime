module Payment
  class RefundReason < ActiveRecord::Base
    belongs_to :refund
  end
end
