class CorrectionsController < ApplicationController
  layout "application"
  def create
    @correction = @solution.corrections.build(params[:correction].permit!)
    @correction.teacher = current_user
    puts @correction.to_json
    if @correction.save
      flash[:success] = "成功创建了#{Correction.model_name.human}"
      redirect_to solution_path(@solution)
    else
      @homework = @solution.homework
      render 'solutions/show'
    end

  end

  private
  def current_resource
    if params[:solution_id]
      @solution = Solution.find(params[:solution_id])
      r = @solution
    end
    r
  end
end
