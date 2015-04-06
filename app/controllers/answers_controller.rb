class AnswersController < ApplicationController

  layout 'vip'
  def create
    @answer = @question.build_a_answer(current_user.id, params[:answer].permit!)
    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def edit

  end

  def update
    if @answer.update_attributes(params[:answer].permit!)
      redirect_to question_path(@answer.question_id)
    else
      render 'edit'
    end
  end
  private
  def current_resource
    if params[:id]
      @answer = Answer.find(params[:id])
    elsif params[:question_id]
      @question = Question.find(params[:question_id])
    end
  end
end
