class VideosController < ApplicationController
  respond_to :json,:js
  #def create
  #  @video = Video.new(params[:video].permit!)
  #  @video.save
  #
  #  if @video.name_integrity_error
  #    @video.errors.add(:name, @video.name_integrity_error)
  #    Rails.logger.info(@video.name_integrity_error)
  #  end
  #  respond_with @video
  #end
  #
  #def update
  #  @video.update_attributes(params[:video].permit!)
  #  respond_with @video
  #end
  #
  #def show
  #  render layout: nil
  #end


  def convert
    @video.add_to_convert_queue
  end
  protected
  def current_resource
    @video = Video.find(params[:id]) if params[:id]
  end
end
