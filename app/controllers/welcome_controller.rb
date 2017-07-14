class WelcomeController < ApplicationController
  layout 'v1/application'

  def download
    @softwares = Software.published.order("position, version desc")
  end

  def courses
    if Rails.env.production?
      @courses = LiveStudio::Course.find(35, 36, 37, 38, 39, 40)
    else
      @courses = LiveStudio::Course.first(6)
    end
    render layout: false
  end

end
