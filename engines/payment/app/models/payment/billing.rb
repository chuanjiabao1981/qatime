module Payment
  class Billing < ActiveRecord::Base
    belongs_to :target, polymorphic: true
  end
end
