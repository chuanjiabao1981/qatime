class CourseIntrosController < ApplicationController
  skip_before_action :authorize
  layout 'v1/video'

  def play
    @course_intro = CourseIntro.find_by(id: params[:id])
    if @course_intro.blank?
      render nothing: true
    end
  end
end
