require_dependency "live_studio/application_controller"

module LiveStudio
  class QuestionsController < ApplicationController
    def index
      @questions = @taskable.questions.includes(:user, :attachments, answer: [:attachments, :user]).paginate(page: params[:page], per_page: 10)
      if current_user.student?
        @student_questions = @taskable.questions.includes(:user, :attachments, answer: [:attachments, :user])
        @student_questions = @student_questions.where(user_id: current_user.id).paginate(page: params[:student_question_page], per_page: 10)
      end
    end

    def new
      @question = @taskable.questions.new
    end

    def create
      @question = @taskable.questions.new(question_params)
      @question.user = current_user

      if @question.save
        render :create
      else
        render :new
      end
    end

    private

    def current_resource
      @taskable = LiveStudio::CustomizedGroup.find(params[:customized_group_id])
    end

    def question_params
      params.require(:question).permit(:title, :body, quotes_attributes: [:id, :attachment_id, :_destroy])
    end
  end
end
