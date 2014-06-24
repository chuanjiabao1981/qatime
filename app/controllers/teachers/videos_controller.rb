class Teachers::VideosController < ApplicationController
  respond_to :json,:js
  def create
    @video = Video.new(params[:video].permit!)
    @video.save
    @download_token = generate_video_download_token
    respond_with @video, @download_token
  end
  def update
    @video.update_attributes(params[:video].permit!)
    @download_token = generate_video_download_token
    respond_with @video
  end
  protected
  def current_resource
    @video = Video.find(params[:id]) if params[:id]
  end
end
