require_dependency "live_studio/application_controller"

module LiveStudio
  class AnswersController < ApplicationController
    def new
      @answer = @question.answer || @question.build_answer
    end

    def create
      @answer = @question.build_answer(answer_params)
      @answer.user = current_user

      if @answer.save
        render :create
      else
        render :new
      end
    end

    def edit
    end

    def update
      LiveStudio::Answer.transaction do
        @answer = @question.build_answer(answer_params)
        @answer.user = current_user
        if @answer.save!
          render
        else
          render :new
        end
      end
    end

    private

    def current_resource
      @question = LiveStudio::Question.find(params[:question_id]) if params[:question_id]
      @answer = LiveStudio::Answer.find(params[:id]) if params[:id]
      @answer || @question
    end

    def answer_params
      params.require(:answer).permit(:body, quotes_attributes: [:id, :attachment_id, :_destroy])
    end
  end
end
