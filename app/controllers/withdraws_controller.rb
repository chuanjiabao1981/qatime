class WithdrawsController < ApplicationController
  def new
    @withdraw = Withdraw.new
  end
  def create
    @withdraw = @account.withdraw(params[:withdraw].permit!,current_user.id)
    if @withdraw.valid? and not @withdraw.new_record?
      flash[:success] = "成功提现#{@withdraw.value}！"
      redirect_to send("info_#{@withdraw.account.accountable.role}_path",@withdraw.account.accountable)
    else
      render 'withdraws/new'
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
