class AccountsController < ApplicationController
  def show
    @account     = Account.find(params[:id])
    @user        = User.find(@account.user_id)
  end
end
