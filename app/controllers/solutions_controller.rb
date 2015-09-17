class SolutionsController < ApplicationController
  layout "application"
  respond_to :html

  def new
    @solution = Solution.new
  end

  def create
    @solution = Solution.new(params[:solution].permit!)
    @solution.student = current_user
    if @solution.save
      flash[:success] = "成功创建#{Solution.model_name.human}"
    end
    respond_with @homework,@solution
  end

  def show

  end
  private
  def current_resource
    if params[:homework_id]
      @homework = Homework.find(params[:homework_id])
      r = @homework
    end
    if params[:id]
      @solution = Solution.find(params[:id])
      r         = @solution
    end
    r
  end

end
