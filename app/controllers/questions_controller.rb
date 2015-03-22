class QuestionsController < ApplicationController

  def index

  end

  def new
    @question = Question.new
    @question.generate_token if @question.token.nil?

  end

  def create

  end

end
