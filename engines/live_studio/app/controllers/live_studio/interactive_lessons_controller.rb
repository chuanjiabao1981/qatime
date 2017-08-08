require_dependency "live_studio/application_controller"

module LiveStudio
  class InteractiveLessonsController < ApplicationController
    layout 'v1/live'
    before_action :set_lesson, only: [:replay]

    def replay
      @lesson = @interactive_lesson
      @course = @interactive_lesson.course
      @video = @interactive_lesson.replays.where(video_for: 0).first
      # @video = Lesson.find(478).replays.where(video_for: 0).first
      @lessons = @course.interactive_lessons.merged.order(:class_date, :live_start_at, :live_end_at)
      PlayRecord.init_play(current_user, @interactive_lesson.course, @interactive_lesson)
    end

    private

    def set_lesson
      @interactive_lesson ||= InteractiveLesson.find(params[:id])
    end

    def current_resource
      set_lesson
    end
  end
end
