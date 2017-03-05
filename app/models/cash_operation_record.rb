class CashOperationRecord < ApplicationRecord
  belongs_to :operator, class_name: User
  belongs_to :account

  validates_numericality_of :value, greater_than: 0
  validates_presence_of :account, :operator
end
