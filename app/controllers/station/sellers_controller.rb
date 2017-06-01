class Station::SellersController < Station::BaseController
  layout 'v1/manager_home'
  before_action :set_seller, only: [:edit, :update, :destroy]
  # GET /workstation/sellers
  # GET /workstation/sellers.json
  def index
    @sellers = Seller.all
  end

  # GET /workstation/sellers/new
  def new
    @seller = Seller.new
  end

  # GET /workstation/sellers/1/edit
  def edit
  end

  # POST /workstation/sellers
  # POST /workstation/sellers.json
  def create
    @seller = @workstation.sellers.new(seller_params)

    respond_to do |format|
      if @seller.save
        format.html { redirect_to station_workstation_sellers_path(@workstation), notice: I18n.t('view.station.sellers.valids.created') }
        format.json { render action: 'show', status: :created, location: @seller }
      else
        format.html { render action: 'new' }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workstation/sellers/1
  # PATCH/PUT /workstation/sellers/1.json
  def update
    respond_to do |format|
      if @seller.update(seller_params)
        format.html { redirect_to station_workstation_sellers_path(@workstation), notice: I18n.t('view.station.sellers.valids.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workstation_seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workstation/sellers/1
  # DELETE /workstation/sellers/1.json
  def destroy
    @seller.destroy
    respond_to do |format|
      format.html { redirect_to station_workstation_sellers_path(@workstation), notice: I18n.t('view.station.sellers.valids.destroy') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seller
    @seller = @workstation.sellers.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seller_params
    params.require(:seller).permit(:name, :email, :password, :password_confirmation, :login_mobile)
  end
end
