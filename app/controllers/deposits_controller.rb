class DepositsController < ApplicationController
  def new
    @deposit = Deposit.new
  end

  def create
    @deposit = @account.deposit(params[:deposit].permit!,current_user.id)
    if @deposit.valid? and not @deposit.new_record?
      flash[:success] = "成功充值#{@deposit.value}！"
      redirect_to send("info_#{@deposit.account.user.role}_path",@deposit.account.user)
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