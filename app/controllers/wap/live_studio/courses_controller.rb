class Wap::LiveStudio::CoursesController < Wap::ApplicationController
  skip_before_action :openid_required!, only: [:download]
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
