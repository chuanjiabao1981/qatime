class EarningRecord < ApplicationRecord
  belongs_to :fee
  belongs_to :account
end
