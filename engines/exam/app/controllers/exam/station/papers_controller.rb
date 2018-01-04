require_dependency "exam/application_controller"

module Exam
  class Station::PapersController < Station::ApplicationController
    before_action :set_paper, only: [:show, :edit, :update, :destroy]

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
      @paper = Exam::JuniorPaper.new(paper_params)
      @paper.workstation = @workstation

      if @paper.save
        redirect_to station_workstation_paper_path(@workstation, @paper), notice: 'Paper was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /station/papers/1
    def update
      if @paper.update(paper_params)
        redirect_to station_workstation_paper_path(@workstation, @paper), notice: 'Paper was successfully created.'
      else
        render :edit
      end
    end

    # DELETE /station/papers/1
    def destroy
      @paper.destroy
      redirect_to exam.station_workstation_papers_path(@workstation), notice: 'Paper was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def paper_params
      params.require(:paper).permit(:name, :grade_category, :subject, :price)
    end

    def search_params
      params.permit(:status)
    end
  end
end
