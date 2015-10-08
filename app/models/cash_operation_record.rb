class CashOperationRecord < ActiveRecord::Base
  belongs_to :operator,:class_name => User
  belongs_to :account

  enum op_type: { :deposit => 0 , :withdraw => 1}
  validates_numericality_of :value,greater_than: 0
  validates_presence_of     :account,:operator
end
