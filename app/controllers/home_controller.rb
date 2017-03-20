class HomeController < ApplicationController
  before_action :set_user
  layout 'application_front'

  def index
    # if signed_in?
    redirect_to action: :new_index
    # else
    #   render layout: 'application_home'
    # end
  end

  def new_index
    home_data = DataService::HomeData.new(@location_city.try(:id))
    @recommend_banners = home_data.banners.order(:index).limit(3)
    @recommend_teachers = home_data.teachers.order(:index).limit(6)
    @today_lives = home_data.today_lives
    @choiceness = home_data.choiceness.order(:index).limit(6)
    @recent_courses = home_data.recent_courses
    @newest_courses = home_data.newest_courses
  end

  def switch_city
    @hash_cities = City.all.to_a.group_by {|city| Spinying.parse(word: city.name).first }.sort.to_h
    @selected_cities = cookies[:selected_cities].try(:split, '-')
  end

  private

  def set_user
    @user = current_user
  end
end
