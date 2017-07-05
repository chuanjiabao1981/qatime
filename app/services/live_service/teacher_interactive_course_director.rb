module LiveService
  class TeacherInteractiveCourseDirector

    def initialize(teacher)
      @teacher = teacher
    end

    # 我的一对一
    def interactive_courses(options = {})
      courses = @teacher.live_studio_interactive_courses.published_start
      courses = courses.finished if options[:status] == 'finished'
      courses = courses.where(status: LiveStudio::InteractiveCourse.statuses[options[:status]]) if LiveStudio::InteractiveCourse.statuses.keys.include? options[:status]
      courses
    end
  end
end
