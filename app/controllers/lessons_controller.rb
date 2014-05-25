class LessonsController < ApplicationController
  respond_to :html
  def show
    @lesson = Lesson.find(params[:id])
    @download_token = generate_video_download_token
  end
end