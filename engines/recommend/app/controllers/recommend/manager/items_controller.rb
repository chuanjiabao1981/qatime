module Recommend
  class Manager::ItemsController < ApplicationController
    before_action :set_position, only: [:new, :create]
    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :set_option_cities, only: [:new, :edit]

    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], type: @position.klass_name))
      unless item_params[:target_id].blank?
        @item.target = User.find(item_params[:target_id]) if @position.klass_name.include?('TeacherItem')
        @item.target = LiveStudio::Course.find(item_params[:target_id]) if @position.klass_name.include?('LiveStudioCourseItem')
      end
      if @item.save
        redirect_to [:manager, @position], notice: 'Item was successfully created.'
      else
        render :new
      end
    end

    def edit
      @position = @item.position
    end

    # PATCH/PUT /admin/items/1
    def update
      if @item.update(item_params.merge(platforms: params[:platforms]))
        redirect_to [:manager, @item.position], notice: 'Item was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/items/1
    def destroy
      @item.destroy
      redirect_to [:manager, @item.position], notice: 'Item was successfully destroyed.'
    end

    private

    def item_params
      key = params.keys.select{|key| /_item/.match(key)}.first
      params.require(key).permit(:title, :index, :link, :city_id, :logo, :target_id, :reason)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_option_cities
      @option_cities = current_user.workstations.map{|w| [w.city.try(:name), w.city.try(:id)]}
    end
  end
end
