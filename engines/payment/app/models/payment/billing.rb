module Payment
  class Billing < ActiveRecord::Base
    belongs_to :target, polymorphic: true

    has_many :billing_items
  end
end
