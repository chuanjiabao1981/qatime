class Managers::LessonsController < ApplicationController
  respond_to :html
  layout "manager_home"
  def state
    if params[:state] == nil
      params[:state] = 'reviewing'
    end
    @lessons = Lesson.all.
        by_state(params[:state]).
        order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def update
    if @lesson.update_attributes(params[:lesson].permit!)
      redirect_to course_path(@lesson.course,lesson_id: @lesson.id)
    else
      render  'courses/show', layout: "application"
    end
  end

  private

  def current_resource
    if params[:id]
      @lesson   = Lesson.find(params[:id])
      @course   = @lesson.course
      @lesson
    end
  end
end
