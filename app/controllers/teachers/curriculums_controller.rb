class Teachers::CurriculumsController < ApplicationController
  layout "application"

  def edit_courses_position
  end
  def update
    return redirect_to curriculum_path(@curriculum) unless params[:curriculum]
    if @curriculum.update_attributes(params[:curriculum].permit!)
      redirect_to curriculum_path(@curriculum)
    else
      render 'edit_courses_position'
    end
  end
  private
  def current_resource
    if params[:id]
      @curriculum = Curriculum.find(params[:id])
    end
  end
end
