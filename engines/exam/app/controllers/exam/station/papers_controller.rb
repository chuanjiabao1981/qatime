require_dependency "exam/application_controller"

module Exam
  class Station::PapersController < Station::ApplicationController
    before_action :set_station_paper, only: [:show, :edit, :update, :destroy]

    # GET /station/papers
    def index
      @papers = @workstation.papers.where(search_params)
      @papers = @papers.paginate(page: params[:page])
    end

    # GET /station/papers/1
    def show
    end

    # GET /station/papers/new
    def new
      @paper = @workstation.papers.new
    end

    # GET /station/papers/1/edit
    def edit
    end

    # POST /station/papers
    def create
      @station_paper = Station::Paper.new(station_paper_params)

      if @station_paper.save
        redirect_to @station_paper, notice: 'Paper was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /station/papers/1
    def update
      if @station_paper.update(station_paper_params)
        redirect_to @station_paper, notice: 'Paper was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /station/papers/1
    def destroy
      @station_paper.destroy
      redirect_to station_papers_url, notice: 'Paper was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_station_paper
        @station_paper = Station::Paper.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def station_paper_params
        params[:station_paper]
      end

      def search_params
        params.permit(:status)
      end
  end
end
