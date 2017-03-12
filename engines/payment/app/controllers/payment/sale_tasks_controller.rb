require_dependency "payment/application_controller"


module Payment
  class SaleTasksController < ApplicationController
    before_action :set_sale_task, only: [:show, :edit, :update, :destroy]

    # GET /sale_tasks
    def index
      @waiting_tasks = SaleTask.all
      @closed_tasks = SaleTask.all
    end

    # GET /sale_tasks/1
    def show
    end

    # GET /sale_tasks/new
    def new
      @sale_task = SaleTask.new
    end

    # GET /sale_tasks/1/edit
    def edit
    end

    # POST /sale_tasks
    def create
      @sale_task = @Workstation.sale_tasks.new(sale_task_params)

      if @sale_task.save
        redirect_to payment.station_workstation_sale_tasks_path(@workstation), notice: 'Sale task was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /sale_tasks/1
    def update
      if @sale_task.update(sale_task_params)
        redirect_to payment.station_workstation_sale_tasks_path(@workstation), notice: 'Sale task was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /sale_tasks/1
    def destroy
      @sale_task.destroy
      redirect_to sale_tasks_url, notice: 'Sale task was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_sale_task
        @sale_task = SaleTask.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def sale_task_params
        params[:sale_task]
      end
  end
end
