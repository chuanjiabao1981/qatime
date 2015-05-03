class TeachingVideosController < ApplicationController

  after_action :allow_qatime_iframe,only: :show
  respond_to :json,:js
  def create
    @teaching_video = TeachingVideo.new(params[:teaching_video].permit!)
    if @teaching_video.save
      @teaching_video.add_to_convert_queue
    end

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

  def allow_qatime_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM http://qatime.cn/'
  end
end
