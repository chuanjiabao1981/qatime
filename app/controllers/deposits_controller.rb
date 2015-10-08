class DepositsController < ApplicationController
  def new
    @deposit = Deposit.new
  end

  def create
    @account = Account.find_by_id(params[:account_id])
    @deposit = @account.deposits.build(params[:deposit].permit!)

    if @deposit.__deposit(@account.user_id)
      flash[:success] = "成功充值！"
    else
      render 'accounts/show'
    end
  end
end