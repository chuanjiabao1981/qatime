class CurriculumsController < ApplicationController
  def show
    @curriculum = Curriculum.includes(:courses).find(params[:id])
  end
end
