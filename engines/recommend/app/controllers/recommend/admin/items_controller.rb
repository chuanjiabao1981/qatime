module Recommend
  class Admin::ItemsController < ApplicationController
    before_action :set_position, only: [:new, :create]
    before_action :set_item, only: [:show, :edit, :update, :destroy]

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_position
      @position = Position.find(params[:position_id])
    end
  end
end
