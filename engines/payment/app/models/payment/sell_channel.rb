module Payment
  class SellChannel < ActiveRecord::Base
    belongs_to :owner, polymorphic: true
    belongs_to :target, polymorphic: true
  end
end
