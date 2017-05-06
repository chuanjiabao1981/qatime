class Wap::LiveStudio::VideoCoursesController < Wap::ApplicationController
  before_action :set_course, only: [:show]

  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @video_course = LiveStudio::VideoCourse.find(params[:id])
  end
end
