class Station::LessonsController < Station::BaseController
  layout 'v1/manager_home'

  respond_to :html

  def state
    params[:state] = 'reviewing' if params[:state].blank?
    @city = @workstation.city
    @lessons = Lesson.all.joins('left outer join users on users.id = lessons.teacher_id').where('users.city_id = ?', @city.id).by_state(params[:state]).order(:created_at).paginate(page: params[:page])
  end

  def update
    @lesson   = Lesson.find(params[:id])
    @course   = @lesson.course
    if @lesson.update_attributes(params[:lesson].permit!)
      redirect_to course_path(@lesson.course, lesson_id: @lesson.id)
    else
      render 'courses/show', layout: "application"
    end
  end
end
