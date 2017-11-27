require_dependency "live_studio/application_controller"

module LiveStudio
  class CorrectionsController < ApplicationController
    def new
      @correction = @student_homework.correction || @student_homework.build_correction
      render unless @correction.new_record?
      @student_homework.task_items.each do |item|
        @correction.task_items.build(parent: item)
      end
    end

    def create
      @correction = @student_homework.build_correction(correction_params)
      @correction.user = current_user
      @correction.taskable = @student_homework.taskable
      if @correction.save && @student_homework.resolved!
        render
      else
        render :new
      end
    end

    def edit
      render unless @student_homework.pending?
      @student_homework.homework.task_items.each do |item|
        @student_homework.task_items.build(parent: item)
      end
    end

    def update
      LiveStudio::Correction.transaction do
        @student_homework.corrections.delete(@correction)
        @correction = @student_homework.build_correction(correction_params)
        @correction.user = current_user
        @correction.taskable = @student_homework.taskable
        if @correction.save! && @student_homework.resolved!
          render
        else
          render :new
        end
      end
    end

    private

    def current_resource
      @student_homework = LiveStudio::StudentHomework.find(params[:student_homework_id])
      @correction = LiveStudio::Correction.find(params[:id]) if params[:id]
      @correction || @student_homework
    end

    def correction_params
      params.require(:correction).permit(task_items_attributes: [:body, :parent_id, quotes_attributes: [:attachment_id, :_destroy]])
    end
  end
end
