require_dependency "recommend/application_controller"

module Recommend
  class Admin::ItemsController < ApplicationController
    before_action :set_position, only: [:new, :create]
    before_action :set_item, only: [:show, :edit, :update, :destroy]

    # GET /admin/items/new
    def new
      @item = @position.items.build(type: @position.klass_name)
    end

    # GET /admin/items/1/edit
    def edit
    end

    # POST /admin/items
    def create
      @item = @position.items.build

      if @item.save
        redirect_to @position, notice: 'Item was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/items/1
    def update
      if @item.update(item_params)
        redirect_to @item, notice: 'Item was successfully updated.'
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
      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = Item.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def item_params
        params.require(:item).permit(:title)
      end

      def set_position
        @position = Position.find(params[:position_id])
      end
  end
end
