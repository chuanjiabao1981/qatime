require_dependency "recommend/application_controller"

module Recommend
  class LiveStudioCourseItemsController < ItemsController

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

      if @item.save(placehold: true)
        redirect_to @position, notice: '推荐创建成功.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      @item.assign_attributes(item_params.merge(platforms: params[:platforms]))
      if @item.save(placehold: true)
        redirect_to @item.position, notice: 'Item was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/items/1
    def destroy
      @item.destroy
      redirect_to @item.position, notice: '推荐删除成功.'
    end

    private

    def item_params
      params.require(:live_studio_course_item).permit(:title, :logo, :target_id, :reason, :city_id, :index)
    end
  end
end
