require_dependency "live_studio/application_controller"

module LiveStudio
  class LessonsController < ApplicationController
    before_action :set_lesson, only: [:play]

    def show
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
    end

    def play
      @paly_record = @course.play_authorize(current_user, @lesson)
      redirect_to [:manager, @course], notice: i18n_notice('has not bought', @course) if @paly_record.nil?
      @teacher = @course.teacher
    end

    def completed
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])

      if @lesson.finished? && LiveService::BillingDirector.new(@lesson).billing
        @lesson.billing? && @lesson.complete!
        redirect_to live_studio.teacher_course_path(@course.teacher, @course, index: :list), notice: t("flash.notice.lesson_completed_success")
      else
        redirect_to live_studio.teacher_course_path(@course.teacher, @course, index: :list), alert: t("flash.alert.lesson_completed_failed")
      end
    end

    def videos
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
      @videos = @lesson.channel_videos.where(video_for: 0)
      @video = @videos.first
      LiveStudio::PlayRecord.init_play(current_user, @course, @lesson)
      render layout: 'live'
    end

    def replay
      @lesson = Lesson.find(params[:id])
      render layout: 'live'
    end

    private

    def set_lesson
      @student = current_user

      @course = @student.live_studio_courses.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])

      redirect_to student_course_path(@course), notice: i18n_notice('lesson_can_not_play', @lesson) unless @lesson.can_play?
    end
  end
end
