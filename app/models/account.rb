class Account < ActiveRecord::Base
  belongs_to :user


  has_many :cash_operation_records
  attr_accessor :withdraw_amount,:deposit_amount,:withdraw_check,:deposit_check

  after_initialize :__init



  validate :validate_withdraw_amount, if: lambda{ self.withdraw_check }
  validate :validate_deposit_amount,  if: lambda{ self.deposit_check  }


  #充值
  def deposit(params,operator_id)
    self.deposit_amount = params[:deposit_amount]
    begin
      self.with_lock do
        self.deposit_check    = true
        if self.valid?
          self.deposit_check  = false
          self.money          = self.money + self.deposit_amount.to_f
          self.save!
          create_deposit_operation_record(self.deposit_amount.to_f,operator_id)
        end
      end
    rescue  ActiveRecord::RecordInvalid => e
      logger.warn e.to_s
      logger.warn self.to_json
      false
    end
  end
  #取现
  def withdraw(params,operator_id)
    self.withdraw_amount = params[:withdraw_amount]
    begin
      self.with_lock do
        # 判断withdraw_amount的format是否合法
        # 判断withdraw_amount的是否小于account.money
        # 通过validate的方法判断的原因是这样可以，设置errors，保证applicaiton层面的统一
        self.withdraw_check  = true
        if self.valid?
          # vlidate通过了后续就可以不检查了
          self.withdraw_check = false
          self.money          = self.money - self.withdraw_amount.to_f
          self.save!
          create_withdraw_operation_record(self.withdraw_amount.to_f,operator_id)
        else
          false
        end
      end
    rescue ActiveRecord::RecordInvalid => e
     logger.warn e.to_s
     logger.warn self.to_json
     false
    end
  end


  private
  def __init
    if self.withdraw_amount.nil? or self.withdraw_amount.blank?
      self.withdraw_amount  = 0
    end
    if self.deposit_amount.nil? or self.deposit_amount.blank?
      self.deposit_amount   = 0
    end
  end

  def create_deposit_operation_record(val,operator_id)
    r = build_cache_operation_record(val,operator_id)
    r.op_type = CashOperationRecord.op_types[:deposit]
    r.save!
  end
  def create_withdraw_operation_record(val,operator_id)
    r = build_cache_operation_record(val,operator_id)
    r.op_type = CashOperationRecord.op_types[:withdraw]
    r.save!
  end


  def build_cache_operation_record(val,operator_id)
    r                 = self.cash_operation_records.build
    r.value           = val
    r.operator_id     = operator_id
    r
  end
  def validate_deposit_amount
    v = parse_raw_value_as_a_number(self.deposit_amount)
    if v
      if v > 0
        if self.money < v
          self.errors.add(:deposit_amount,"账户资金不足，无法提取!")
        end
      else
        self.errors.add(:deposit_amount,"请输大于0的数字")
      end
    else
      self.errors.add(:deposit_amount,"请输入数字")
    end
  end
  def validate_withdraw_amount
    v = parse_raw_value_as_a_number(self.withdraw_amount)
    if v
      if v > 0
        if self.money < v
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
