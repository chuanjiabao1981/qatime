class EarningRecord < ActiveRecord::Base
  belongs_to :fee
  belongs_to :account
end
