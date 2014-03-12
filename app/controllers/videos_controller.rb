class VideosController < ApplicationController
  respond_to :json,:js
  def create
    @video = Video.new(params[:video].permit!)
    @video.save
    respond_with @video
  end
  def update
    @video = Video.find(params[:id])
    @video.update_attributes(params[:video].permit!)
    respond_with @videos
  end
end
