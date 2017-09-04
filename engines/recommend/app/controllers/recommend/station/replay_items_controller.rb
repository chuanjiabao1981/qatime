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
      @course_options = @lesson_options = []
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], city_id: @workstation.city_id, type: @position.klass_name))
      @item.target_type = 'LiveStudio::Lesson' if @item.course_type == 'course'
      @item.target_type = 'LiveStudio::InteractiveLesson' if @item.course_type == 'interactive_course'
      @item.target_type = 'LiveStudio::ScheduledLesson' if @item.course_type == 'group'
      @item.course_required = true

      if @item.save
        flash_msg(:success)
        redirect_to recommend.station_workstation_replay_items_path(@workstation, position_id: @position)
      else
        load_options
        render :new
      end
    end

    def edit
      load_options
    end

    def update
      @item.course_required = true
      @item.target_type = 'LiveStudio::Lesson' if item_params[:course_type] == 'course'
      @item.target_type = 'LiveStudio::InteractiveLesson' if item_params[:course_type] == 'interactive_course'
      @item.target_type = 'LiveStudio::ScheduledLesson' if item_params[:course_type] == 'group'
      if @item.update(item_params.merge(platforms: params[:platforms]))
        flash_msg(:success)
        redirect_to recommend.station_workstation_replay_items_path(@workstation, position_id: @position)
      else
        load_options
        render :edit
      end
    end

    def destroy
      @item.destroy
      redirect_to recommend.station_workstation_replay_items_path(@workstation, position_id: @position)
    end

    private

    def load_options
      @course = @item.course
      @course_options = @lesson_options = []
      return if @course.blank?

      @item.course_id = @course.id

      if @course.is_a?(LiveStudio::Course)
        @item.course_type = 'course'
        @course_options = LiveStudio::Course.pluck(:name, :id)
        @lesson_options = @course.lessons.merged.pluck(:name, :id)
      end

      if @course.is_a?(LiveStudio::InteractiveCourse)
        @item.course_type = 'interactive_course'
        @course_options = LiveStudio::InteractiveCourse.pluck(:name, :id)
        @lesson_options = @course.interactive_lessons.merged.pluck(:name, :id)
      end

      if @course.is_a?(LiveStudio::CustomizedGroup)
        @item.course_type = 'group'
        @course_options = LiveStudio::CustomizedGroup.pluck(:name, :id)
        @lesson_options = @course.scheduled_lessons.merged.pluck(:name, :id)
      end
    end

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_item
      @item = @position.items.where(city_id: @workstation.city_id).find(params[:id])
    end

    def item_params
      params.require(:replay_item).permit(:course_id, :course_type, :target_id, :target_type, :city_id, :top)
    end
  end
end
