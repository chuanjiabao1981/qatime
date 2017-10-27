require_dependency "recommend/application_controller"

module Recommend
  class Station::ChoicenessItemsController < Station::ApplicationController
    before_action :set_position
    before_action :set_item, only: [:edit, :update, :destroy]
    before_action :set_courses_options

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
        redirect_to recommend.station_workstation_choiceness_items_path(@workstation, position_id: @position)
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
        redirect_to recommend.station_workstation_choiceness_items_path(@workstation, position_id: @position)
      else
        render :edit
      end
    end

    def destroy
      @item.destroy
      redirect_to recommend.station_workstation_choiceness_items_path(@workstation, position_id: @position)
    end

    def ajax_course_select
      @choiceness_item = ChoicenessItem.find_by(id: params[:id])
      if params[:target_type].blank?
        @courses_options = []
        return
      end

      @choiceness_item = nil unless @choiceness_item.try(:target_type) == params[:target_type]
      @course_model = ChoicenessItem.target_type.find_value(params[:target_type]).try(:value).camelize.constantize rescue ::LiveStudio::Course
      @courses_options = @course_model.where(workstation_id: @workstation.id).pluck(:name, :id)
    end

    private

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_item
      @item = @position.items.where(city_id: @workstation.city_id).find(params[:id])
    end

    def set_courses_options
      return @courses_options = [] if @item.try(:target).blank?
      # 分别查询不同课程
      @course_model = @item.try(:target).present? ? @item.target.class : LiveStudio::Course
      @courses_options = @course_model.where(workstation_id: @workstation.id).pluck(:name, :id)
    end

    def item_params
      params.require(:choiceness_item).permit(:title, :index, :link, :target_id, :target_type, :city_id, :tag_one, :tag_two)
    end
  end
end
