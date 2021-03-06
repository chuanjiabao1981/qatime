class Admins::WorkstationWithdrawsController < ApplicationController
  before_action :find_withdraw, only: [:audit]

  respond_to :html
  layout "admin_home"

  def index
    params[:audit] ||= 'no_audit'
    @workstation_withdraws = Payment::Withdraw.station

    if params[:audit] == 'no_audit'
      @workstation_withdraws = @workstation_withdraws.where(status: Payment::Withdraw.statuses['init'])
    else
      @workstation_withdraws = @workstation_withdraws.where(status: Payment::Withdraw.statuses.values_at('allowed', 'refused'))
    end
    @query = @workstation_withdraws.ransack(params[:q])
    @workstation_withdraws = @query.result.paginate(page: params[:page])
  end

  def audit
    case params[:audit]
      when 'allow'
        @workstation_withdraw.allow! if @workstation_withdraw.may_allow?
      when 'refuse'
        @workstation_withdraw.refuse! if @workstation_withdraw.may_refuse?
    end
    flash_msg(:success)
    redirect_to :back
  end

  private

  def find_withdraw
    @workstation_withdraw = Payment::Withdraw.find(params[:id])
  end

end
