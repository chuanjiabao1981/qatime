class HomeController < ApplicationController
  layout 'application_front'
  before_action :set_user
  def index
    #redirect_to user_home_path if signed_in?
    @recommend_courses = Recommend::Item.where(type: 'Recommend::LiveStudioCourseItem')
    @recommend_teachers = Recommend::Item.where(type: 'Recommend::TeacherItem')
  end

  private
  def set_user
    @user = current_user
  end
end
