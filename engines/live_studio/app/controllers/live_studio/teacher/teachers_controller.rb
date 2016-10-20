#require_dependency "live_studio/application_controller"
module LiveStudio
  class Teacher::TeachersController < Teacher::BaseController
    def schedules
      @wait_lessons = @teacher.live_studio_lessons.unclosed
      @close_lessons = @teacher.live_studio_lessons.already_closed
      render 'live_studio/student/students/schedules'
    end

    def settings
      @setting = NotificationSetting.find_by(owner: @teacher) || NotificationSetting.default
    end
  end
end
