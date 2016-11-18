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
    set_city
    @recommend_courses, @recommend_teachers, @recommend_banners = DataService::HomeData.home_data_by_city(@city.try(:id))
    @user_path = @user.blank? ? signin_path : (!@user.student? && !@user.teacher? && !@user.manager? && 'javascript:void(0);')
  end

  def switch_city
    @hash_cities = ::Util.group_cities
    @selected_cities = cookies[:selected_cities].try(:split, '-')
  end

  private
  def set_user
    @user = current_user
  end

  def set_city
    cookie_city = cookies[:selected_cities].try(:split, '-').try(:first)
    @city = City.find_by(id: params[:city_id]) || City.find_by(name: params[:city_name] || cookie_city)
    return if @city.blank?
    selected_cities = cookies[:selected_cities].try(:split, '-') || []
    selected_cities.delete(@city.name) if selected_cities.include?(@city.name)
    selected_cities = selected_cities.insert(0, @city.name)
    cookies[:selected_cities] = selected_cities.uniq.try(:join, '-')
    @city
  end
end
