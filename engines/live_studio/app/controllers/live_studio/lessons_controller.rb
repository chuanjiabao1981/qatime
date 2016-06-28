require_dependency "live_studio/application_controller"

module LiveStudio
  class LessonsController < ApplicationController
    before_action :set_lession, only: [:play]

    def show
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
    end

    def play
      @paly_record = @course.play_authorize(current_user, @lesson)
      redirect_to [:manager, @course], notice: i18n_notice('has not bought', @course) if @paly_record.nil?
      @teacher = @course.teacher
    end

    private

    def set_lession
      @student = current_user

      @course = @student.live_studio_courses.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])

      redirect_to student_course_path(@course), notice: i18n_notice('lesson_can_not_play', @lesson) unless @lesson.can_play?
    end

  end
end
