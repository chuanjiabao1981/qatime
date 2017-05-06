require_dependency "recommend/application_controller"

module Recommend
  class BannerItemsController < ApplicationController
    before_action :set_position, only: [:index, :new, :create]
    before_action :set_item, only: [:edit, :update, :destroy]
    before_action :set_option_cities

    def index
      @items = workstation_filter(@position.items).order(:index).paginate(page: params[:page])
    end

    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    # GET /admin/items/1/edit
    def edit
      @position = @item.position
    end

    # POST /admin/items
    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], type: @position.klass_name))

      if @item.save
        flash_msg(:success)
        redirect_to position_banner_items_path(@position)
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      if @item.update(item_params.merge(platforms: params[:platforms]))
        flash_msg(:success)
        redirect_to position_banner_items_path(@item.position)
      else
        render :edit
      end
    end

    # DELETE /admin/items/1
    def destroy
      @item.destroy
      redirect_to :back
    end

    private

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def set_option_cities
      @option_cities = City.all.map {|city| [city.try(:name), city.try(:id)]}.unshift([I18n.t('view.recommend/position.city'), nil]) if current_user.admin?
      @option_cities ||= current_user.workstations.map {|w| [w.city.try(:name), w.city.try(:id)]}
    end

    def workstation_filter(chain)
      return chain if current_user.admin?
      city_ids = current_user.manager? ? current_user.workstations.map(&:city_id) : [current_user.workstation.city_id]
      chain.where(city_id: city_ids)
    end

    def item_params
      params.require(:banner_item).permit(:title, :logo, :index, :link, :city_id)
    end
  end
end
