class Managers::WaitersController < ApplicationController
  before_action :set_waiter, only: [:show, :edit, :update, :destroy]

  # GET /managers/waiters/1
  # GET /managers/waiters/1.json
  def show
  end

  # GET /managers/waiters/new
  def new
    @waiter = Waiter.new
    @workstations = current_user.workstations.select(:id, :name).map {|w| [w.name, w.id] }
  end

  # GET /managers/waiters/1/edit
  def edit
  end

  # POST /managers/waiters
  # POST /managers/waiters.json
  def create
    @waiter = Waiter.new(waiter_params)

    respond_to do |format|
      if @waiter.save
        format.html { redirect_to waiters_manager_path(current_user), notice: i18n_notice('created',@waiter) }
        format.json { render action: 'show', status: :created, location: @waiter }
      else
        @workstations = current_user.workstations.select(:id, :name).map {|w| [w.name, w.id] }
        format.html { render action: 'new' }
        format.json { render json: @waiter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /managers/waiters/1
  # PATCH/PUT /managers/waiters/1.json
  def update
    respond_to do |format|
      if @waiter.update(waiter_params.slice(:name, :email, :mobile))
        format.html { redirect_to waiters_manager_path(current_user), notice: i18n_notice('updated',@waiter) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @waiter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/waiters/1
  # DELETE /managers/waiters/1.json
  def destroy
    @waiter.destroy
    respond_to do |format|
      format.html { redirect_to waiters_manager_path(current_user) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waiter
      @waiter = Waiter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def waiter_params
      params.require(:waiter).permit(:name, :email, :password, :password_confirmation, :mobile, :workstation_id)
    end
end
