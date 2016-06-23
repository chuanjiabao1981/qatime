require_dependency "live_studio/application_controller"

module LiveStudio
  class LessonsController < ApplicationController
    before_action :set_lession, only: [:show, :play]

    def show
    end

    def play
    end

    private

    def set_lession
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
    end

  end
end
