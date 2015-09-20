class SolutionsController < ApplicationController
  layout "application"
  respond_to :html

  def new
    @solution = @solutionable.solutions.build
  end

  def create
    @solution = @solutionable.solutions.build(params[:solution].permit!)
    @solution.student = current_user
    if @solution.save
      flash[:success] = "成功创建#{Solution.model_name.human}"
      @solution.notify
    end
    respond_with @solutionable,@solution
  end

  def show
    @correction = Correction.new
    @corrections = @solution.corrections.order(:created_at).paginate(page: params[:page])
  end


  def edit

  end

  def update
    if @solution.update_attributes(params[:solution].permit!)
      flash[:success] = "成功修改#{Solution.model_name.human}"
    end
    respond_with  @solution
  end
  def destroy
    @solution.destroy
    @solutionable = @solution.solutionable
    respond_with @solutionable
  end
  private
  def current_resource
    if params[:homework_id]
      @solutionable = Homework.find(params[:homework_id])
      r = @solutionable
    end
    if params[:id]
      @solution     = Solution.find(params[:id])
      r             = @solution
      @solutionable = @solution.solutionable
    end
    r
  end

end
