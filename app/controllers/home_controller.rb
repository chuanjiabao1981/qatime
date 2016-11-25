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
    @recommend_courses, @recommend_teachers, @recommend_banners = DataService::HomeData.home_data_by_city(@location_city.try(:id))
    @user_path = @user.blank? ? signin_path : (!@user.student? && !@user.teacher? && !@user.manager? && 'javascript:void(0);')
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
