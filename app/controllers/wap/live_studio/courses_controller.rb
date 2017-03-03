class Wap::LiveStudio::CoursesController < Wap::ApplicationController
  before_action :set_course, only: [:show]

  def show
  end

  def download
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = LiveStudio::Course.find(params[:id])
  end
end
