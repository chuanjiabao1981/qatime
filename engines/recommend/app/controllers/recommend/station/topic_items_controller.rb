require_dependency "recommend/application_controller"

module Recommend
  class Station::TopicItemsController < Station::ApplicationController
    before_action :set_position
    before_action :set_item, only: [:edit, :update, :destroy]

    def index
      @items = @position.items.where(city_id: @workstation.city_id).order(:index).paginate(page: params[:page])
    end

    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], city_id: @workstation.city_id, type: @position.klass_name))

      if @item.save(placehold: true)
        flash_msg(:success)
        redirect_to recommend.station_workstation_topic_items_path(@workstation, position_id: @position)
      else
        render :new
      end
    end

    def edit
    end

    def update
      @item.assign_attributes(item_params.merge(platforms: params[:platforms]))
      if @item.save(placehold: true)
        flash_msg(:success)
        redirect_to recommend.station_workstation_topic_items_path(@workstation, position_id: @position)
      else
        render :edit
      end
    end

    def destroy
      @item.destroy
      redirect_to recommend.station_workstation_topic_items_path(@workstation, position_id: @position)
    end

    private

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_item
      @item = @position.items.where(city_id: @workstation.city_id).find(params[:id])
    end

    def item_params
      params.require(:topic_item).permit(:name, :title, :index, :link, :city_id)
    end
  end
end
