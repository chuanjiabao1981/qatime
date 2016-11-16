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
    @recommend_courses = Recommend::LiveStudioCourseItem.limit(6)
    @recommend_teachers = Recommend::TeacherItem.limit(5)
    @user_path = @user.blank? ? signin_path : (!@user.student? && !@user.teacher? && 'javascript:void(0);')
  end

  def switch_city
    @hash_cities = ::Util.group_cities
    @selected_cities = cookies[:selected_cities].try(:split, '-').try(:sort){ |x,y| y <=> x }
  end

  private
  def set_user
    @user = current_user
  end

  def set_city
    @city = City.find_by(id: params[:city_id]) || City.find_by(name: params[:city_name])
    return if @city.blank?
    selected_cities = cookies[:selected_cities].try(:split, '-').try(:sort){ |x,y| y <=> x } || []
    selected_cities = selected_cities.insert(0, @city.name).sort
    cookies[:selected_cities] = selected_cities.uniq.try(:join, '-')
    @city
  end
end
