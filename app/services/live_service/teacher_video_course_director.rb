module LiveService
  class TeacherVideoCourseDirector

    def initialize(teacher)
      @teacher = teacher
    end

    # 我的视频课
    def video_courses(options = {})
      courses = @teacher.live_studio_video_courses
      courses = courses.unpublished if options[:status] == 'unpublished'
      courses = courses.where(status: LiveStudio::VideoCourse.statuses[options[:status]]) if LiveStudio::VideoCourse.statuses.keys.include? options[:status]
      courses
    end

  end
end
