require_dependency "recommend/application_controller"

module Recommend
  class PositionsController < ApplicationController
    layout :current_user_layout

    # GET /positions
    def index
      @positions = Position.all.paginate(page: params[:page])
    end

    # GET /positions/1
    def show
      @position = Position.find(params[:id])
      @items = workstation_filter(@position.items).order(id: :desc).paginate(page: params[:page])
    end

    private

    def workstation_filter(chain)
      return chain if current_user.admin?
      city_ids = current_user.manager? ? current_user.workstations.map(&:city_id) : [current_user.workstation.city_id]
      chain.where(city_id: city_ids)
    end
  end
end
