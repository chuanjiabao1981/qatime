require_dependency "live_studio/application_controller"

module LiveStudio
  class LessonsController < ApplicationController
    before_action :set_lession, only: [:show, :play]

    def show
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
    end

    def play
      @student.
    end

    private

    def set_lession
      @student = current_user

      @course = @student.live_studio_courses.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])

      redirect_to root_path, notice: t("view.lesson.lesson_can_not_play") if @lesson.can_play?
    end

  end
end
