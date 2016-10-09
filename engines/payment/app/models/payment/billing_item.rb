module Payment
  class BillingItem < ActiveRecord::Base
    belongs_to :billing
    belongs_to :account, polymorphic: true
  end
end
