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
      if @answer.update(answer_params)
        render :update
      else
        render :edit
      end
    end

    private

    def current_resource
      @question = LiveStudio::Question.find(params[:question_id]) if params[:question_id]
      @answer = LiveStudio::Answer.find(params[:id]) if params[:id]
      @answer || @question
    end

    def answer_params
      params.require(:answer).permit(:title, :body)
    end
  end
end
