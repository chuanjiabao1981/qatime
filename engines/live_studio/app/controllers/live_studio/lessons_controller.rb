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
      @lesson = Lesson.find(params[:id])

      if @lesson.finished? && BusinessService::CourseBillingDirector.new(@lesson).billing_lesson
        @lesson.billing? && @lesson.complete!
        redirect_to live_studio.teacher_course_path(@lesson.teacher, @lesson.course, index: :list), notice: t("flash.notice.lesson_completed_success")
      else
        redirect_to live_studio.teacher_course_path(@lesson.teacher, @lesson.course, index: :list), alert: t("flash.alert.lesson_completed_failed")
      end
    end

    def videos
      @lesson = Lesson.find(params[:id])
      @course = @lesson.course
      @video = @lesson.replays.where(video_for: 0).first
      @lessons = Lesson.where(course_id: @lesson.course_id, replay_status: LiveStudio::Lesson.replay_statuses[:merged])
      LiveStudio::PlayRecord.init_play(current_user, @lesson.course, @lesson)
      # 临时解决方案
      @paly_records = LiveStudio::PlayRecord.where(lesson_id: @lessons.map(&:id),
                                                   play_type: LiveStudio::PlayRecord.play_types[:replay],
                                                   user_id: current_user.id).where('created_at < ?', Date.today).to_a
      @lessons.each do |l|
        l.replay_times = @paly_records.select {|record| record.lesson_id == l.id }.count
      end
      render layout: 'live'
    end

    def replay
      @lesson = Lesson.find(params[:id])
      @course = @lesson.course
      @video = @lesson.replays.where(video_for: 0).first
      @lessons = Lesson.where(course_id: @lesson.course_id, replay_status: LiveStudio::Lesson.replay_statuses[:merged])
      @lessons = @lessons.order(:class_date, :live_start_at, :live_end_at)
      LiveStudio::PlayRecord.init_play(current_user, @lesson.course, @lesson)
      # 临时解决方案
      @paly_records = LiveStudio::PlayRecord.where(lesson_id: @lessons.map(&:id),
                                                   play_type: LiveStudio::PlayRecord.play_types[:replay],
                                                   user_id: current_user.id).where('created_at < ?', Date.today).to_a
      @lessons.each do |l|
        l.replay_times = @paly_records.select {|record| record.lesson_id == l.id }.count
      end
      render layout: 'v1/live'
    end

    private

    def set_lesson
      @student = current_user

      @course = @student.live_studio_courses.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])

      redirect_to student_course_path(@course), notice: i18n_notice('lesson_can_not_play', @lesson) unless @lesson.can_play?
    end

    def current_resource
      @lesson = Lesson.find(params[:id])
    end
  end
end
