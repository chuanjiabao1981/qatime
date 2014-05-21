class LessonsController < ApplicationController
  respond_to :html
  def show
    @lesson = Lesson.find(params[:id])
    generate_download_token
  end

  def generate_download_token
    @download_token = Qiniu::RS.generate_download_token :expires_in => 300,
                                      :pattern => "uploads/*"
  end
end
