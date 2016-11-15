require_dependency "recommend/application_controller"

module Recommend
  class Admin::BannerItemsController < Admin::ItemsController
    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    # GET /admin/items/1/edit
    def edit
      @position = @item.position
    end

    # POST /admin/items
    def create
      @item = @position.items.build(item_params.merge(target_type: nil, type: @position.klass_name))

      if @item.save
        redirect_to [:admin, @position], notice: 'Item was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      if @item.update(item_params)
        redirect_to [:admin, @item.position], notice: 'Item was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/items/1
    def destroy
      @item.destroy
      redirect_to [:admin, @item.position], notice: 'Item was successfully destroyed.'
    end

    private

    def item_params
      params.require(:banner_item).permit(:title, :index, :link, :logo)
    end
  end
end
