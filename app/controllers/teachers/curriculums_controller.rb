class Teachers::CurriculumsController < ApplicationController
  def edit_courses_position
    #
  end
  def update
    if @curriculum.update_attributes(params[:curriculum].permit!)
      redirect_to curriculum_path(@curriculum)
    else
      #params[:chapter] = "运动的描述"
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
