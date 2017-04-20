class HomeController < ApplicationController
  before_action :set_user
  layout 'v1/application'

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
    @today_lives = home_data.today_lives.limit(12)
    @choiceness = home_data.choiceness.order(:index).paginate(page: 1, per_page: 8)
    @recent_courses = home_data.recent_courses.limit(4)
    @newest_courses = home_data.newest_courses.limit(4)
  end

  def switch_city
    @hash_cities = City.all.to_a.group_by {|city| Spinying.parse(word: city.name).first }.sort.to_h
    @selected_cities = cookies[:selected_cities].try(:split, '-')
    render layout: 'application_front'
  end

  private

  def set_user
    @user = current_user
  end
end
