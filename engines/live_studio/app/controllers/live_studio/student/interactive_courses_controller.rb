require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::InteractiveCoursesController < Student::BaseController
    layout 'v1/home'

    def index
      @interactive_courses = @student.live_studio_bought_interactive_courses.includes(interactive_lessons: [:teacher])
      @interactive_courses = @interactive_courses.where(status: status_filter)
      @interactive_courses = @interactive_courses.paginate(page: params[:page])
    end

    private
    def status_filter
      if params[:status] == 'teaching'
        LiveStudio::InteractiveCourse.statuses.values_at(:teaching)
      elsif params[:status] == 'finished'
        LiveStudio::InteractiveCourse.statuses.values_at(:completed, :refunded)
      else
        LiveStudio::InteractiveCourse.statuses.values_at(:teaching, :completed, :refunded)
      end
    end
  end
end
