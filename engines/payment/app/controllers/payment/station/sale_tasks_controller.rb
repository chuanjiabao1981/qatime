require_dependency "payment/application_controller"

module Payment
  class Station::SaleTasksController < Station::BaseController
    before_action :set_sale_task, only: [:show, :edit, :update, :destroy, :start, :close]

    # GET /sale_tasks
    def index
      # 未结束
      @waiting_tasks = if current_user.admin?
                         @workstation.sale_tasks.unclosed
                       else
                         @workstation.sale_tasks.ongoing
                       end
      @waiting_tasks = @waiting_tasks.reorder(started_at: :asc)
      @closed_tasks = @workstation.sale_tasks.closed.paginate(page: params[:page])
      render layout: 'v1/manager_home'
    end

    # GET /sale_tasks/1
    def show
    end

    # GET /sale_tasks/new
    def new
      @latest_date = @workstation.sale_tasks.reorder('ended_at').last.try(:ended_at).try(:since, 1.day)
      @latest_date ||= Time.now
      @sale_task = SaleTask.new(started_at: @latest_date)
    end

    # GET /sale_tasks/1/edit
    def edit
    end

    # POST /sale_tasks
    def create
      @sale_task = @workstation.sale_tasks.new(sale_task_params)

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

    # 开始
    def start
      @sale_task.start! if @sale_task.unstart?
      redirect_to payment.station_workstation_sale_tasks_path(@workstation)
    end

    def close
      @sale_task.close! if @sale_task.ongoing?
      redirect_to payment.station_workstation_sale_tasks_path(@workstation)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_sale_task
        @sale_task = @workstation.sale_tasks.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def sale_task_params
        params[:sale_task]
      end
  end
end
