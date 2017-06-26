require_dependency "recommend/application_controller"

module Recommend
  class Station::ReplayItemsController < Station::ApplicationController
    before_action :set_position
    before_action :set_item, only: [:edit, :update, :destroy]

    def index
      @items = @position.items.where(city_id: @workstation.city_id)
      @items = @items.top if params[:top].present?
      @items = @items.order(updated_at: :desc).paginate(page: params[:page])
    end

    def new
      @item = @position.items.build(type: @position.klass_name)
      @lesson_options = []
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], target_type: 'LiveStudio::Lesson', city_id: @workstation.city_id, type: @position.klass_name))
      @item.course_required = true
      if @item.save
        flash_msg(:success)
        redirect_to recommend.station_workstation_replay_items_path(@workstation, position_id: @position)
      else
        @lesson_options = @item.course.lessons.merged.pluck(:name, :id) rescue []
        render :new
      end
    end

    def edit
      @item.course_id = @item.try(:target).try(:course_id)
      @lesson_options = @item.course.lessons.merged.pluck(:name, :id) rescue []
    end

    def update
      @item.course_required = true
      if @item.update(item_params.merge(platforms: params[:platforms]))
        flash_msg(:success)
        redirect_to recommend.station_workstation_replay_items_path(@workstation, position_id: @position)
      else
        @item.course_id = @item.try(:target).try(:course_id)
        @lesson_options = @item.course.lessons.merged.pluck(:name, :id) rescue []
        render :edit
      end
    end

    def destroy
      @item.destroy
      redirect_to recommend.station_workstation_replay_items_path(@workstation, position_id: @position)
    end

    private

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_item
      @item = @position.items.where(city_id: @workstation.city_id).find(params[:id])
    end

    def item_params
      params.require(:replay_item).permit(:course_id, :target_id, :target_type, :city_id, :top)
    end
  end
end
