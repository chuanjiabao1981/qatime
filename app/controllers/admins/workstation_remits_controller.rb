class Admins::WorkstationRemitsController < ApplicationController
  before_action :find_withdraw, only: [:new, :create]

  respond_to :html
  layout "admin_home"

  def index
    params[:remit] ||= 'no_remit'
    status = params[:remit] == 'no_remit' ? Payment::Withdraw.statuses['allowed'] : Payment::Withdraw.statuses['paid']
    @query = Payment::Withdraw.station.where(status: status).ransack(params[:q])
    @workstation_remits = @query.result.paginate(page: params[:page])
  end

  def new

  end

  def create

  end

  private

  def find_withdraw
    @workstation_remit = Payment::Withdraw.find(params[:withdraw_id])
  end

end
