require_dependency "live_studio/application_controller"

module LiveStudio
  class ScheduledLessonsController < ApplicationController
    layout 'v1/live'
    before_action :set_lesson, only: [:replay]

    def replay
      @course = @lesson.group
      @video = @lesson.replays.where(video_for: 0).first
      @lessons = @course.scheduled_lessons.merged.order(:start_at)
      PlayRecord.init_play(current_user, @course, @lesson)
    end

    private

    def set_lesson
      @lesson ||= ScheduledLesson.find(params[:id])
    end

    def current_resource
      set_lesson
    end
  end
end
