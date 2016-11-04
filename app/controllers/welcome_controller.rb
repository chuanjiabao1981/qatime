class WelcomeController < ApplicationController
  layout "application"

  def download
    render && return unless current_user
    @softwares = Software.auto_sort(current_user)
    flag_hash = {}
    # 以title分组的数据 只取第一条进行展示
    @softwares.each do |soft|
      flag_hash["#{soft.category}#{soft.platform}"] || flag_hash["#{soft.category}#{soft.platform}"] = soft
    end
    @softwares = flag_hash.values
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
end
