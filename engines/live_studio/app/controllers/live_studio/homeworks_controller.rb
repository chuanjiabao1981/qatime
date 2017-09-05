require_dependency "live_studio/application_controller"

module LiveStudio
  class HomeworksController < ApplicationController
    def index
      @homeworks = @taskable.homeworks
      @student_homeworks = @taskable.student_homeworks
    end

    def new
      @homework = @taskable.homeworks.new
      @homework.task_items.build
    end

    def create
      @homework = @taskable.homeworks.new(homework_params)
      @homework.user = current_user

      if @homework.save
        render :create
      else
        render :new
      end
    end

    private

    def current_resource
      @taskable = LiveStudio::CustomizedGroup.find(params[:customized_group_id])
    end

    def homework_params
      params.require(:homework).permit(:title, task_items_attributes: [:body])
    end
  end
end
