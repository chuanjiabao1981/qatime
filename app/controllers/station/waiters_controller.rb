class Station::WaitersController < Station::BaseController
  layout 'v1/manager_home'

  before_action :set_waiter, only: [:edit, :update, :destroy]
  # GET /workstation/waiters
  # GET /workstation/waiters.json
  def index
    @waiters = Waiter.all
  end

  # GET /workstation/waiters/new
  def new
    @waiter = Waiter.new
  end

  # GET /workstation/waiters/1/edit
  def edit
  end

  # POST /workstation/waiters
  # POST /workstation/waiters.json
  def create
    @waiter = @workstation.waiters.new(waiter_params)

    respond_to do |format|
      if @waiter.save
        format.html { redirect_to station_workstation_waiters_path(@workstation), notice: I18n.t('view.station.waiters.valids.created') }
        format.json { render action: 'show', status: :created, location: @waiter }
      else
        format.html { render action: 'new' }
        format.json { render json: @waiter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workstation/waiters/1
  # PATCH/PUT /workstation/waiters/1.json
  def update
    respond_to do |format|
      if @waiter.update(waiter_params)
        format.html { redirect_to station_workstation_waiters_path(@workstation), notice: I18n.t('view.station.waiters.valids.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workstation_waiter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workstation/waiters/1
  # DELETE /workstation/waiters/1.json
  def destroy
    @waiter.destroy
    respond_to do |format|
      format.html { redirect_to station_workstation_waiters_path(@workstation), notice: I18n.t('view.station.waiters.valids.d') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_waiter
    @waiter = @workstation.waiters.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def waiter_params
    params.require(:waiter).permit(:name, :email, :password, :password_confirmation, :login_mobile)
  end
end
