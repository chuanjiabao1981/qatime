require_dependency "recommend/application_controller"

module Recommend
  class BannerItemsController < ItemsController
    before_action :set_item

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

      if @item.save
        redirect_to @position, notice: '推荐创建成功.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      if @item.update(item_params.merge(platforms: params[:platforms]))
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

    def set_item
      @item = Recommend::BannerItem.find(params[:id])
    end

    def item_params
      params.require(:banner_item).permit(:title, :logo, :target_id, :reason, :city_id, :index)
    end
  end
end
