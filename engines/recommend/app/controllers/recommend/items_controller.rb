module Recommend
  class ItemsController < ApplicationController
    before_action :set_position, only: [:new, :create]
    before_action :set_option_cities, only: [:new, :edit]
    before_action :set_item, only: [:show, :edit, :update, :destroy]

    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    def create
      @item = @position.items.build(item_params.merge(platforms: params[:platforms], type: @position.klass_name))
      unless item_params[:target_id].blank?
        @item.target = User.find(item_params[:target_id]) if @position.klass_name.include?('TeacherItem')
        @item.target = LiveStudio::Course.find(item_params[:target_id]) if @position.klass_name.include?('LiveStudioCourseItem')
      end
      if @item.save(placehold: true)
        redirect_to @position, notice: '推荐创建成功.'
      else
        render :new
      end
    end

    private

    def set_position
      @position = Position.find(params[:position_id])
    end

    def set_option_cities
      @option_cities = City.all.map {|city| [city.try(:name), city.try(:id)]}.unshift(['全国', nil]) if current_user.admin?
      @option_cities ||= current_user.workstations.map {|w| [w.city.try(:name), w.city.try(:id)]}
    end

    def item_params
      key = params.keys.select {|key| /_item/.match(key)}.first
      params.require(key).permit(:index, :link, :city_id, :logo, :target_id, :reason)
    end

    def set_item
      @item = Item.find(params[:id])
    end
  end
end
