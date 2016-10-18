require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentsController < Student::BaseController
    def schedules
      @wait_lessons = @student.live_studio_lessons.unclosed
      @close_lessons = @student.live_studio_lessons.already_closed
    end

    def settings
      @setting = NotificationSetting.find_or_initialize_by(owner: @student)
    end
  end
end
