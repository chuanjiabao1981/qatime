require_dependency "live_studio/application_controller"

module LiveStudio
  class StudentHomeworksController < ApplicationController
    def edit
      render unless @student_homework.pending?
      @student_homework.homework.task_items.each do |item|
        @student_homework.task_items.build(parent: item)
      end
    end

    def update
      if @student_homework.update(student_homework_params)
        render :update
      else
        render :edit
      end
    end

    private

    def current_resource
      @student_homework = LiveStudio::StudentHomework.find(params[:id])
    end

    def student_homework_params
      params.require(:student_homework).permit(task_items_attributes: [:parent_id, :body, quotes_attributes: [:id, :attachment_id, :_destroy]])
    end
  end
end
