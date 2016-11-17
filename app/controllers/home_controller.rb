class HomeController < ApplicationController
  before_action :set_user
  def index
    # if signed_in?
    redirect_to action: :new_index
    # else
    #   render layout: 'application_home'
    # end
  end

  def new_index
    @recommend_courses, @recommend_teachers, @recommend_banners = DataService::HomeData.home_data_by_city(params[:city_id])
    @user_path = @user.blank? ? signin_path : (!@user.student? && !@user.teacher? && !@user.manager? && 'javascript:void(0);')
    render layout: 'application_front'
  end

  private
  def set_user
    @user = current_user
  end
end
