class Account < ActiveRecord::Base
  belongs_to :user

  has_many :cash_operation_records



  #充值
  def deposit(params,operator_id)
    _account_operation(params,operator_id) do |params|
      params[:op_type]          = CashOperationRecord.op_types[:deposit]
    end
  end


  #取现
  def withdraw(params,operator_id)
    _account_operation(params,operator_id) do |params|
      params[:op_type]          = CashOperationRecord.op_types[:withdraw]
    end
  end

  def _account_operation(params,operator_id,&block)
    params[:op_type]          = CashOperationRecord.op_types[:deposit]
    params[:operator_id]      = operator_id
    yield params
    _cash_operation_record    = nil
    self.with_lock do
      _cash_operation_record = self.cash_operation_records.create(params)
      if _cash_operation_record and _cash_operation_record.valid? and not _cash_operation_record.new_record?
        _change_money _cash_operation_record
      end
    end
    _cash_operation_record
  end
  def _change_money(cor)
    if cor.deposit?
      self.money = self.money + cor.value
    elsif cor.withdraw?
      self.money = self.money - cor.value
    else
      raise ActiveRecord::StatementInvalid, " cash opertaion type is wrong " + cor.to_json
    end
    self.save!
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
