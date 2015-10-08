class Account < ActiveRecord::Base
  belongs_to :user



  attr_accessor :withdraw_amount


  after_initialize :__init

  validates_numericality_of :withdraw_amount,greater_than_or_equal_to: 0

  #充值
  def deposit
    self.account
  end

  #取现
  def withdraw(params)
    self.withdraw_amount = params[:withdraw_amount]

  end


  private
  def __init
    if self.withdraw_amount.nil? or self.withdraw_amount.blank?
      self.withdraw_amount = 0
    end
  end


end
