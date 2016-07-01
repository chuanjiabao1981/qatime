require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    def index
      @tickets = current_user.live_studio_tickets.visiable.includes(course: :teacher)
    end

    def show
      @course = Course.find(params[:id])
      @ticket = current_user.live_studio_tickets.visiable.find_by(course_id: params[:id])
      @lessons = @course.lessons
      @play_records = PlayRecord.where(user_id: current_user.id, lesson_id: @lessons.map(&:id))
      @play_hash = @play_records.inject({}){ |hash, v| hash[v.lesson_id] = v.id; hash }
    end
  end
end
