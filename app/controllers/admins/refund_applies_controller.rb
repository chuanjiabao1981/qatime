class Admins::RefundAppliesController < ApplicationController

  respond_to :html
  layout "admin_home"

  def index
    @refund_applies = Payment::RefundApply.all.page(params[:page])
  end

  def audit
    @refund_applies = params[:init] == 'audit' ? Payment::RefundApply.where.not(status: Payment::RefundApply.statuses['init']) :  Payment::RefundApply.init
    @refund_applies = @refund_applies.filter(params[:keyword])
    @refund_applies = @refund_applies.paginate(page: params[:page],per_page: 10)
  end

  def pass
    @refund_apply = Payment::RefundApply.find(params[:id])
    @refund_apply.allow!(current_user)
    redirect_to action: :audit
  end

  def unpass
    @refund_apply = Payment::RefundApply.find(params[:id])
    @refund_apply.refuse!(current_user)
    redirect_to action: :audit
  end
end
