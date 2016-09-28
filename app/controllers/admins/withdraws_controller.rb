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
end
