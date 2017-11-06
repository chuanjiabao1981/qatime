require_dependency "recommend/application_controller"

module Recommend
  class TopicItemsController < ApplicationController
    before_action :set_position, only: [:index, :new, :create]
    before_action :set_item, only: [:edit, :update, :destroy]
    before_action :set_option_cities

    def index
      @items = @position.items.order(:index).paginate(page: params[:page])
    end

    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], type: @position.klass_name))

      if @item.save(placehold: true)
        flash_msg(:success)
        redirect_to position_topic_items_path(@position)
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
        redirect_to position_topic_items_path(@item.position)
      else
        render :edit
      end
    end

    def destroy
      @position = @item.position
      @item.destroy
      redirect_to position_topic_items_path(@position)
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

    def item_params
      params.require(:topic_item).permit(:name, :title, :index, :link, :city_id)
    end
  end
end
