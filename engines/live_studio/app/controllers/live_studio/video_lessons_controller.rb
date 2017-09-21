require_dependency "live_studio/application_controller"

module LiveStudio
  class VideoLessonsController < ApplicationController
    before_action :set_lesson, only: [:play]

    def play
      @lesson = @video_lesson
      @course = @video_lesson.video_course
      @video_file = @lesson.video_file
      @lessons = VideoLesson.where(video_course_id: @lesson.video_course_id)

      @course.tickets.by_student_id(current_user.id).available.each do |ticket|
        LiveStudio::PlayRecord.init_play(current_user, @course, @lesson, ticket)
      end
      render layout: 'v1/live'
    end

    private

    def set_lesson
      @video_lesson ||= VideoLesson.find(params[:id])
    end

    def current_resource
      set_lesson
    end
  end
end
