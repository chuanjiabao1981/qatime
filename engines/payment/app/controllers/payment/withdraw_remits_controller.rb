require_dependency "payment/application_controller"

module Payment
  class WithdrawRemitsController < ApplicationController
    layout "admin_home"

    before_action :find_withdraw, only: [:new, :create]

    def index
      params[:remit] ||= 'no_remit'
      status = params[:remit] == 'no_remit' ? Withdraw.statuses['allowed'] : Withdraw.statuses['paid']
      @query = Withdraw.station.where(status: status).ransack(params[:q])
      @withdraw_remits = @query.result.paginate(page: params[:page])
    end

    def new
      @withdraw_remit = @withdraw.build_withdraw_remit
    end

    def create
      @withdraw_remit = WithdrawRemit.new(withdraw_remit_params)
      @withdraw_remit.target = @withdraw

      if @withdraw_remit.save
        flash_msg(:success)
        redirect_to payment.withdraw_remits_path(remit: 'remit')
      else
        render :new
      end
    end

    private

    def find_withdraw
      @withdraw = Withdraw.find(params[:withdraw_id])
    end

    def withdraw_remit_params
      params.require(:withdraw_remit).permit(:pay_type, :pay_username, :remit_at, :pic)
    end
  end
end
