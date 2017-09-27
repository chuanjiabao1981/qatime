require_dependency "live_studio/application_controller"

module LiveStudio
  class HomeworksController < ApplicationController
    def index
      @homeworks = @taskable.homeworks.paginate(page: params[:homework_page], per_page: 10).includes(:user, :task_items)
      @student_homeworks = @taskable.student_homeworks.includes(:user, :task_items, homework: [:user, :task_items], correction: [:user, :task_items])
      @student_homeworks =
        if current_user.student?
          @student_homeworks.where(user_id: current_user.id)
        else
          @student_homeworks.published
        end
      @student_homeworks = @student_homeworks.paginate(page: params[:student_page], per_page: 10)
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
      params.require(:homework).permit(:title, task_items_attributes: [:body, quotes_attributes: [:attachment_id, :_destroy]])
    end
  end
end
