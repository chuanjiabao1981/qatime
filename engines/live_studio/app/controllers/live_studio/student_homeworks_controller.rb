require_dependency "live_studio/application_controller"

module LiveStudio
  class StudentHomeworksController < ApplicationController
    before_action :taskable_resource, only: [:index]

    def index
      @student_homeworks = @taskable_resource.student_homeworks
    end

    def new
      @student_homework = @homework.student_homeworks.new(homework: @homework)
      @homework.task_items.each do |item|
        @student_homework.task_items.build(parent: item)
      end
    end

    def create
      @student_homework = @homework.student_homeworks.new(student_homework_params)
      @student_homework.user = current_user

      if @student_homework.save
        render :create
      else
        render :new
      end
    end

    private

    def current_resource
      @homework = LiveStudio::Homework.find(params[:homework_id])
    end

    def taskable_resource
      @taskable_resource = LiveStudio::CustomizedGroup.find(params[:customized_group_id])
    end

    def student_homework_params
      params.require(:student_homework).permit(task_items_attributes: [:body])
    end
  end
end
