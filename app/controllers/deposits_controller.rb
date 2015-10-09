class DepositsController < ApplicationController
  def new
    @deposit = Deposit.new
  end

  def create
    if   @account.deposit(params[:account],current_user_id)
      flash[:success] = "成功充值#{params[:account][:deposit_amount]}！"
    else
      render 'deposits/new'
    end
  end

  private
  def current_resource
    if params[:account_id]
      @account = Account.find(params[:account_id])
      r = @account
    end
    r
  end
end