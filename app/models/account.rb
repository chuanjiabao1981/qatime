class Account < ActiveRecord::Base
  belongs_to :accountable,polymorphic: true

  has_many  :deposits
  has_many  :withdraws
  has_many  :earning_records
  has_many  :consumption_records


  #充值
  def deposit(params,operator_id)
    _account_operation(params,operator_id) do |params|
      self.deposits.create(params)
    end
  end


  #取现
  def withdraw(params,operator_id)
    _account_operation(params,operator_id) do |params|
      self.withdraws.create(params)
    end
  end

  def _account_operation(params,operator_id,&block)
    params[:operator_id] = operator_id
    _cash_operation_record    = nil
    self.with_lock do
      _cash_operation_record =     yield params
      if _cash_operation_record and _cash_operation_record.valid? and not _cash_operation_record.new_record?
        self.money = self.money +  _cash_operation_record.change_money
        self.save
      end
    end
    _cash_operation_record
  end


end
