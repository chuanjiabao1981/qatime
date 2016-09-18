require_dependency "payment/application_controller"

module Payment
  class RechargesController < ApplicationController
    before_action :set_resource_user
    before_action :set_recharge, only: [:show, :edit, :update, :destroy]

    # GET /recharges
    def index
      @recharges = @resource_user.payment_recharges.paginate(page: params[:page])
    end

    # GET /recharges/1
    def show
    end

    # GET /recharges/new
    def new
      @recharge = Recharge.new
    end

    # GET /recharges/1/edit
    def edit
    end

    # POST /recharges
    def create
      @recharge = @resource_user.payment_recharges.new(recharge_params)

      if @recharge.save
        redirect_to @recharge, notice: 'Recharge was successfully created.'
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
        @recharge ||= Recharge.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def recharge_params
        params.require(:recharge).permit(:amount, :created_at, :status)
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
