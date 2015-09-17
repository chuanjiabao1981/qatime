class SolutionsController < ApplicationController
  layout "application"
  def new
    @solution = Solution.new
  end


  private
  def current_resource
    if params[:homework_id]
      @homework = Homework.find(params[:homework_id])
      r = @homework
    end
    r
  end
end
