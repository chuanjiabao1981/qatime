module LiveStudio
  class CashAccount < ActiveRecord::Base
    belongs_to :user
  end
end
