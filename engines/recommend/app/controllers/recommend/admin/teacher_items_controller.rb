require_dependency "recommend/application_controller"

module Recommend
  class Admin::TeacherItemsController < Admin::ItemsController
    def new
    end

    # GET /admin/items/1/edit
    def edit
    end

    # POST /admin/items
    def create
      @item = @position.items.build(teacher_item_params.merge(target_type: Teacher, type: @position.klass_name))

      if @item.save
        redirect_to [:admin, @position], notice: 'Item was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      if @admin_item.update(admin_item_params)
        redirect_to @admin_item, notice: 'Item was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/items/1
    def destroy
      @admin_item.destroy
      redirect_to admin_items_url, notice: 'Item was successfully destroyed.'
    end

    private

    def item_params
      params.require(:teacher_item).permit(:title, :logo, :target_id)
    end
  end
end
