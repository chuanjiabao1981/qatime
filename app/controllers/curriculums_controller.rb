class CurriculumsController < ApplicationController
  respond_to :html

  def index
    @curriculums = Curriculum.all.where("courses_count > 0").order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def show
    @curriculum = Curriculum.includes(:courses).find(params[:id])
  end
end
