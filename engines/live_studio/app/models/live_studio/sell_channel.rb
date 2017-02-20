module LiveStudio
  class SellChannel < ActiveRecord::Base
    belongs_to :owner, polymorphic: true
    belongs_to :target, polymorphic: true

    has_many :buy_tickets
  end
end
