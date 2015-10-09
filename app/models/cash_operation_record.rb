class CashOperationRecord < ActiveRecord::Base
  belongs_to :operator,:class_name => User
  belongs_to :account

  enum op_type: { :deposit => 0 , :withdraw => 1}
  validates_numericality_of :value,greater_than: 0
  validates_presence_of     :account,:operator
  attr_accessor :account_money_snap_shot

  validate :validate_withdraw_amount, if: lambda {self.withdraw?}
  private
  def validate_withdraw_amount
    v = parse_raw_value_as_a_number(self.value)
    if self.account_money_snap_shot.nil?
      self.account_money_snap_shot = self.account.money
    end
    if v
      if v > 0
        if self.account_money_snap_shot < v
          self.errors.add(:withdraw_amount,"账户资金不足，无法提取!")
        end
      else
        self.errors.add(:withdraw_amount,"请输大于0的数字")
      end
    else
      self.errors.add(:withdraw_amount,"请输入数字")
    end
  end

  def parse_raw_value_as_a_number(raw_value)
    Kernel.Float(raw_value) if raw_value !~ /\A0[xX]/
  rescue ArgumentError, TypeError
    nil
  end
end
