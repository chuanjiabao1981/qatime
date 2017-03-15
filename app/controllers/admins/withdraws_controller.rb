class Admins::WithdrawsController < ApplicationController

  respond_to :html
  layout "admin_home"

  def index
    @withdraws = Payment::Withdraw.all
    @withdraws = @withdraws.where(status: Payment::Withdraw.statuses[params[:status]]) if params[:status].present?
    if params[:start_time].present? && params[:end_time].present?
      start_time = params[:start_time].gsub('.','-')
      end_time = params[:end_time].gsub('.','-')
      @withdraws = @withdraws.where('updated_at >= ? and updated_at <= ?',start_time,end_time)
    end
    @withdraws = @withdraws.filter(params[:keyword])
    @withdraws = @withdraws.page(params[:page])
  end

  def audit
    @withdraws = params[:init] == 'audit' ? Payment::Withdraw.where.not(status: Payment::Withdraw.statuses['init']) :  Payment::Withdraw.init
    @withdraws = @withdraws.filter(params[:keyword])
    @withdraws = @withdraws.paginate(page: params[:page], per_page: 10)
  end

  def pass
    @withdraw = Payment::Withdraw.find(params[:id])
    @withdraw.allow!(current_user)
    redirect_to action: :audit
  end

  def unpass
    @withdraw = Payment::Withdraw.find(params[:id])
    @withdraw.refuse!(current_user)
    redirect_to action: :audit
  end
end
