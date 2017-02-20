require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentsController < Student::BaseController

    def schedules
      @wait_lessons = @student.live_studio_lessons.unclosed
      @close_lessons = @student.live_studio_lessons.already_closed.reorder(id: :desc)
    end

    def settings
      @setting = NotificationSetting.find_by(owner: @student) || NotificationSetting.default
    end
  end
end
