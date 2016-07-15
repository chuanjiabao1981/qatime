class Managers::SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]

  # GET /managers/sellers
  # GET /managers/sellers.json
  def index
    @sellers = current_user.sellers.order('id desc').paginate(page: params[:page])
  end

  # GET /managers/sellers/1
  # GET /managers/sellers/1.json
  def show
  end

  # GET /managers/sellers/new
  def new
    @seller = Seller.new
    @workstations = current_user.workstations.select(:id, :name).map {|w| [w.name, w.id] }
  end

  # GET /managers/sellers/1/edit
  def edit
  end

  # POST /managers/sellers
  # POST /managers/sellers.json
  def create
    @seller = Seller.new(seller_params)

    respond_to do |format|
      if @seller.save
        format.html { redirect_to sellers_manager_url(current_user), notice: i18n_notice('created', @seller) }
        format.json { render action: 'show', status: :created, location: @seller }
      else
        format.html { render action: 'new' }
        @workstations = current_user.workstations.select(:id, :name).map {|w| [w.name, w.id] }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /managers/sellers/1
  # PATCH/PUT /managers/sellers/1.json
  def update
    respond_to do |format|
      if @seller.update(seller_params.slice(:name, :email, :mobile))
        format.html { redirect_to sellers_manager_url(current_user), notice: i18n_notice('updated', @seller) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/sellers/1
  # DELETE /managers/sellers/1.json
  def destroy
    @seller.destroy
    respond_to do |format|
      format.html { redirect_to sellers_manager_url(current_user) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = Seller.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seller_params
      params.require(:seller).permit(:name, :email, :password, :password_confirmation, :mobile, :workstation_id)
    end
end
