class LessonsController < ApplicationController
  respond_to :html
  def show
    @lesson = Lesson.find(params[:id])
  end
end