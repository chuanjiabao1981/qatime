require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    layout 'v1/home'

    def index
      @courses = @student.live_studio_bought_courses.where(status: filter_status).includes(:lessons).paginate(page: params[:page])
    end

    def show
      @course = Course.find(params[:id])
      @ticket = @student.live_studio_tickets.by_product(@course).try(:first)
      @lessons = @course.lessons.order(:id).paginate(page: params[:page])
      @play_records = PlayRecord.where(user_id: @student.id, lesson_id: @lessons.map(&:id))
      @play_hash = @play_records.inject({}){ |hash, v| hash[v.lesson_id] = v.id; hash }
    end

    private

    def filter_status
      LiveStudio::Course.statuses[params[:status] || 'published']
    end
  end
end
