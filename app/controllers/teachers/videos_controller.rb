class Teachers::VideosController < ApplicationController
  respond_to :json,:js
  def create
    @video_player_id = rand(10000)
    @video = Video.new(params[:video].permit!)
    if @video.save
      @video.add_to_convert_queue
    end

    if @video.name_integrity_error
      @video.errors.add(:name, @video.name_integrity_error)
      Rails.logger.info(@video.name_integrity_error)
    end
    respond_with @video
  end

  def update
    @video_player_id = rand(10000)
    @video.update_video_file(params[:video].permit!)
    respond_with @video
  end
  protected
  def current_resource
    @video = Video.find(params[:id]) if params[:id]
  end
end