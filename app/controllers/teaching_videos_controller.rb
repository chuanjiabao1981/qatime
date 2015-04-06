class TeachingVideosController < ApplicationController
  respond_to :json,:js
  def create
    @teaching_video = TeachingVideo.new(params[:teaching_video].permit!)
    @teaching_video.save

    if @teaching_video.name_integrity_error
      @teaching_video.errors.add(:name, @teaching_video.name_integrity_error)
      Rails.logger.info(@teaching_video.name_integrity_error)
    end
    respond_with @teaching_video
  end

  def show
    render layout: 'teaching_video'
  end
  protected
  def current_resource
    @teaching_video = TeachingVideo.find(params[:id]) if params[:id]
  end
end
