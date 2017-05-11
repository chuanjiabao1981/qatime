require_dependency "payment/application_controller"

module Payment
  class RechargesController < ApplicationController
    layout 'v1/application'

    before_action :set_resource_user
    before_action :set_recharge, only: [:show, :edit, :update, :destroy, :pay]

    # GET /recharges
    def index
      @recharges = @resource_user.payment_recharges.paginate(page: params[:page])
    end

    # GET /recharges/1
    def show
    end

    # GET /recharges/new
    def new
      @cash_account = @resource_user.cash_account
      @recharge = Recharge.new(amount: params[:amount])
    end

    # GET /recharges/1/edit
    def edit
    end

    def pay
      Payment::Recharge.transaction do
        action_record = Payment::RechargeActionRecord.create(
          actionable: @recharge,
          operator: current_user,
          from: @recharge.status,
          event: "pay",
          name: "pay"
        )
        @recharge.pay!
        action_record.to = @recharge.status
        action_record.save!
      end if current_user.admin? && @recharge.pay_type.offline? # 为了防止权限配置疏忽这里只有管理员才能授权线下支付
      redirect_to payment.cash_user_path(@recharge.user_id)
    end

    # POST /recharges
    def create
      @recharge = @resource_user.payment_recharges.new(recharge_params.merge(remote_ip: request.remote_ip, source: :web))
      @cash_account = @resource_user.cash_account

      if @recharge.save
        redirect_to payment.transaction_path(@recharge.transaction_no)
      else
        render :new
      end
    end

    # PATCH/PUT /recharges/1
    def update
      if @recharge.update(recharge_params)
        redirect_to @recharge, notice: 'Recharge was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /recharges/1
    def destroy
      @recharge.destroy
      redirect_to recharges_url, notice: 'Recharge was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_recharge
        @recharge ||= Recharge.find_by_transaction_no!(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def recharge_params
        params.require(:recharge).permit(:amount, :pay_type)
      end

      def set_resource_user
        @resource_user ||= if params[:user_id]
                             User.find(params[:user_id])
                           else
                             set_recharge.user
                           end
        @resource_owner = @resource_user
      end

      def current_resource
        @current_resource ||= set_resource_user
      end
  end
end
