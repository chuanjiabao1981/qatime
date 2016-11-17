require_dependency "recommend/application_controller"

module Recommend
  class Manager::PositionsController < ApplicationController

    # GET /admin/positions
    def index
      @positions = Position.all.paginate(page: params[:page])
    end

    # GET /admin/positions/1
    def show
      @position = Position.find params[:id]
      @items = @position.items.where(city_id:  current_user.workstations.map(&:city_id)).paginate(page: params[:page])
    end
  end
end
