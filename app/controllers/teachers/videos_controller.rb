class Teachers::VideosController < ApplicationController
  respond_to :json,:js
  def create
    @video = Video.new(params[:video].permit!)
    @video.save
    respond_with @video
  end
  def update
    @video.update_attributes(params[:video].permit!)
    respond_with @video
  end
  protected
  def current_resource
    @video = Video.find(params[:id]) if params[:id]
  end
end
