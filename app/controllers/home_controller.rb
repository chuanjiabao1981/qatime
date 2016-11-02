class HomeController < ApplicationController
  layout 'application_home'
  def index
    redirect_to user_home_path if signed_in?
    @recommend_courses = Recommend::Position.all
  end

  private
  def set_user
    @user = current_user
  end
end
