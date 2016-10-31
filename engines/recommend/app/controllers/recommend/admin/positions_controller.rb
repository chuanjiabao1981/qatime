require_dependency "recommend/application_controller"

module Recommend
  class Admin::PositionsController < ApplicationController
    before_action :set_position, only: [:show, :edit, :update, :destroy]

    # GET /admin/positions
    def index
      @positions = Position.all.paginate(page: params[:page])
    end

    # GET /admin/positions/1
    def show
      @items = @position.items.paginate(page: params[:page])
    end

    # GET /admin/positions/new
    def new
      @position = Position.new
    end

    # GET /admin/positions/1/edit
    def edit
    end

    # POST /admin/positions
    def create
      @position = Position.new(position_params.merge(status: 0))

      if @position.save
        redirect_to [:admin, @position], notice: 'Position was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/positions/1
    def update
      if @position.update(position_params)
        redirect_to [:admin, @position], notice: 'Position was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/positions/1
    def destroy
      @position.destroy
      redirect_to admin_positions_url, notice: 'Position was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_position
        @position = Position.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def position_params
        params.require(:position).permit(:name, :kee, :klass_name)
      end
  end
end
