require_dependency "recommend/application_controller"

module Recommend
  class TeacherItemsController < ApplicationController
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
      @item = @position.items.build(item_params.merge(platforms: params[:platforms],target_type: Teacher, type: @position.klass_name))

      if @item.save(placehold: true)
        flash_msg(:success)
        redirect_to position_teacher_items_path(@position)
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      @item.assign_attributes(item_params.merge(platforms: params[:platforms]))
      if @item.save(placehold: true)
        flash_msg(:success)
        redirect_to position_teacher_items_path(@item.position)
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

      @teacher_options = Teacher.pluck(:name, :id) if current_user.admin?
      city_ids = current_user.manager? ? current_user.workstations.map(&:city_id) : [current_user.try(:workstation).try(:city_id)]
      @teacher_options ||= Teacher.where(city_id: city_ids).pluck(:name, :id)
    end

    def workstation_filter(chain)
      return chain if current_user.admin?
      city_ids = current_user.manager? ? current_user.workstations.map(&:city_id) : [current_user.workstation.city_id]
      chain.where(city_id: city_ids)
    end

    def item_params
      params.require(:teacher_item).permit(:title, :index, :link, :target_id, :city_id)
    end
  end
end
