module Payment
  class CashOperationRecord < ActiveRecord::Base
    belongs_to :operator,class_name: ::User
    belongs_to :account

    validates_numericality_of :value,greater_than: 0,only_integer: true
    validates_presence_of     :account,:operator
  end
end
