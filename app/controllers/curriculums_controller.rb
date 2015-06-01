class CurriculumsController < ApplicationController
  layout "application"
  respond_to :html

  def index
    @curriculums = Curriculum.all.
                  by_teaching_program(params[:teaching_program_id]).
                  by_subject(params[:subject]).
                  by_passed_teacher(current_user).
                  where("courses_count > 0").order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def show
    @curriculum = Curriculum.includes(courses:[:lessons]).find(params[:id])
  end
end
