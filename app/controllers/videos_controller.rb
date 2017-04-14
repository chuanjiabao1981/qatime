class VideosController < ApplicationController
  respond_to :json,:js
  def new
  end

  def create
    @video_player_id = rand(10000)
    @video = Video.new(params[:video].permit!)
    @video.author_id = current_user.id
    if @video.save
      @video.add_to_convert_queue
    end

    if @video.name_integrity_error
      @video.errors.add(:name, @video.name_integrity_error)
      Rails.logger.info(@video.name_integrity_error)
    end
    @video.sync_info if params[:capture]
    respond_with @video
  end

  def update
    @video_player_id = rand(10000)
    @video.update_video_file(params[:video].permit!)
    @video.sync_info if params[:capture]
    respond_with @video
  end
  def convert
    @video.add_to_convert_queue
  end
  protected
  def current_resource
    @video = Video.find(params[:id]) if params[:id]
  end
end
