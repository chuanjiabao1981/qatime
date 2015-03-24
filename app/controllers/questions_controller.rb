class QuestionsController < ApplicationController

  respond_to :html
  def index

  end

  def new
    @question = Question.new
    @question.generate_token if @question.token.nil?

  end

  def create
    @question = current_user.questions.build(params[:question].permit!)
    @question.save
    respond_with @question
  end

  def edit

  end
  def update
    @question.update_attributes(params[:question].permit!)
    respond_with @question
  end
  def show
    @answer = Answer.new
  end

  private
  def current_resource
    @question  = Question.find(params[:id]) if params[:id]
  end

end
