class CorrectionsController < ApplicationController
  layout "application"
  def create
    @correction = @solution.corrections.build(params[:correction].permit!)
    @correction.teacher = current_user
    if @correction.save
      flash[:success] = "成功创建了#{Correction.model_name.human}"
      @correction.notify
      redirect_to solution_path(@solution)
    else
      @homework = @solution.homework
      render 'solutions/show'
    end

  end


  def edit

  end

  def update
    if @correction.update_attributes(params[:correction].permit!)
      flash[:success] = "成功编辑了#{Correction.model_name.human}"
      redirect_to solution_path(@correction.solution)
    else
      render 'edit'
    end
  end

  private
  def current_resource
    if params[:solution_id]
      @solution = Solution.find(params[:solution_id])
      r = @solution
    end
    if params[:id]
      @correction = Correction.find(params[:id])
      @solution   = @correction.solution
      r = @correction
    end
    r
  end
end
