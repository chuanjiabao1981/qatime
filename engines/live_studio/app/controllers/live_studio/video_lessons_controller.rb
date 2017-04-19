require_dependency "live_studio/application_controller"

module LiveStudio
  class VideoLessonsController < ApplicationController
    before_action :set_lesson, only: [:play]

    def play
      @lesson = @video_lesson
      @course = @video_lesson.video_course
      @video = @lesson.video
      @lessons = VideoLesson.where(video_course_id: @lesson.video_course_id)
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
