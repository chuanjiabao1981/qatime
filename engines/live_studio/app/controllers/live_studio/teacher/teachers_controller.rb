#require_dependency "live_studio/application_controller"
module LiveStudio
  class Teacher::TeachersController < Teacher::BaseController
    layout 'v1/home'

    def schedules
      course_lessons = @teacher.live_studio_lessons
      interactive_course_lessons = @teacher.live_studio_interactive_lessons

      @wait_lessons = course_lessons.unclosed.to_a + interactive_course_lessons.unclosed.to_a
      @close_lessons = course_lessons.already_closed.to_a + interactive_course_lessons.already_closed.to_a
      @wait_lessons = @wait_lessons.sort_by {|x| x.start_at }.reverse
      @close_lessons = @close_lessons.sort_by {|x| x.start_at }
      render 'live_studio/student/students/schedules'
    end

    def settings
      @setting = NotificationSetting.find_by(owner: @teacher) || NotificationSetting.default
    end
  end
end
