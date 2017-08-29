require_dependency "live_studio/application_controller"

module LiveStudio
  class InteractiveLessonsController < ApplicationController
    layout 'v1/live_video'
    before_action :set_lesson, only: [:replay]

    def replay
      @lesson = @interactive_lesson
      @course = @interactive_lesson.interactive_course
      @replays = @interactive_lesson.replays.board.merged.order(:id)
      @current_replay = @replays.find_by(vid: params[:vid]).presence || @replays.first
      @lessons = @course.interactive_lessons.merged.includes(:replays).order(:class_date, :live_start_at, :live_end_at)
      PlayRecord.init_play(current_user, @course, @lesson)
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
