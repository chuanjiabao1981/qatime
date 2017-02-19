class WelcomeController < ApplicationController
  layout "application"

  def download
    @softwares = Software.published.order("software_category_id, version desc")
    render layout: 'application_front'
  end

  def courses
    if Rails.env.production?
      @courses = LiveStudio::Course.find(35, 36, 37, 38, 39, 40)
    else
      @courses = LiveStudio::Course.first(6)
    end
    render layout: false
  end

  def index
  end

  def ping
    puts Rails.root
    render text: 'yyyyyyyyyyyyy'
  end
end
