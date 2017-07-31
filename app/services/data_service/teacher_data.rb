module DataService
  class TeacherData
    def initialize(teacher)
      @teacher = teacher
    end

    def profile_courses
      @profile_courses = @teacher.live_studio_courses.published_start.order(:status)
    end

    def more_profile_course?
      @profile_courses.count > 6
    end

    def profile_interactive_courses
      @profile_interactive_courses = @teacher.live_studio_interactive_courses.published_start.order(:status)
    end

    def more_profile_interactive_course?
      @profile_interactive_courses.count > 6
    end

    def profile_video_courses
      @profile_video_courses = @teacher.live_studio_video_courses.for_sell
    end

    def more_profile_video_course?
      @profile_video_courses.count > 6
    end

    def profile_customized_groups
      @profile_customized_groups = @teacher.live_studio_customized_groups.order(:status)
    end

    def more_profile_customized_group?
      @profile_customized_groups.count > 6
    end
  end
end
