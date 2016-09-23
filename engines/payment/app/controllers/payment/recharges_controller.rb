require_dependency "payment/application_controller"

module Payment
  class RechargesController < ApplicationController
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
      render :new, layout: 'payment'
    end

    # GET /recharges/1/edit
    def edit
    end

    # POST /recharges
    def create
      @recharge = @resource_user.payment_recharges.new(recharge_params.merge(remote_ip: request.remote_ip, source: :web))
      @cash_account = @resource_user.cash_account

      if @recharge.save
        redirect_to payment.pay_recharge_path(@recharge.transaction_no), notice: 'Recharge was successfully created.'
      else
        render :new, layout: 'payment'
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

    def pay
      render layout: 'payment'
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
