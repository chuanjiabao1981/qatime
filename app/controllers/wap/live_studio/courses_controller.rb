class Wap::LiveStudio::CoursesController < Wap::ApplicationController
  before_action :set_course

  # GET /wap/live_studio/courses/1
  # GET /wap/live_studio/courses/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = LiveStudio::Course.find(params[:id])
  end
end
