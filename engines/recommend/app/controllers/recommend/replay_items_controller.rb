require_dependency "recommend/application_controller"

module Recommend
  class ReplayItemsController < ApplicationController
    before_action :set_position, only: [:index, :new, :create]
    before_action :set_item, only: [:edit, :update, :destroy]
    before_action :set_option_cities

    def index
      @items = @position.items
      @items = @items.top if params[:top].present?
      @items = @items.order(updated_at: :desc).paginate(page: params[:page])
    end

    def new
      @item = @position.items.build(type: @position.klass_name)
      @lesson_options = []
    end

    def edit
      @item.course_id = @item.try(:target).try(:course_id)
      @lesson_options = @item.course.lessons.merged.pluck(:name, :id) rescue []
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], target_type: 'LiveStudio::Lesson', type: @position.klass_name))
      @item.course_required = true
      if @item.save
        flash_msg(:success)
        redirect_to recommend.position_replay_items_path(@position)
      else
        @lesson_options = @item.course.lessons.merged.pluck(:name, :id) rescue []
        render :new
      end
    end

    def update
      @item.course_required = true
      if @item.update(item_params.merge(platforms: params[:platforms]))
        flash_msg(:success)
        redirect_to position_replay_items_path(@item.position)
      else
        @item.course_id = @item.try(:target).try(:course_id)
        @lesson_options = @item.course.lessons.merged.pluck(:name, :id) rescue []
        render :edit
      end
    end

    def destroy
      @position = @item.position
      @item.destroy
      redirect_to position_replay_items_path(@position)
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
      params.require(:replay_item).permit(:course_id, :target_id, :target_type, :city_id, :top)
    end
  end
end
