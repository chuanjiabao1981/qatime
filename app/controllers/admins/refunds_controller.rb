class Admins::RefundsController < ApplicationController

  respond_to :html
  layout "admin_home"

  def index
    @refunds = Payment::Refund.all.page(params[:page])
  end

  def audit
    @refunds = params[:init] == 'audit' ? Payment::Refund.where.not(status: Payment::Refund.statuses['init']) : Payment::Refund.init
    @refunds = @refunds.filter(params[:keyword])
    @refunds = @refunds.paginate(page: params[:page], per_page: 10)
  end

  def pass
    @refund = Payment::Refund.find(params[:id])
    @refund.allow_by!(current_user)
    redirect_to action: :audit
  end

  def unpass
    @refund = Payment::Refund.find(params[:id])
    @refund.refuse_by!(current_user)
    redirect_to action: :audit
  end
end
