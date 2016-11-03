class HomeController < ApplicationController
  layout 'application_front'
  before_action :set_user
  def index
    redirect_to action: :new_index if signed_in?
  end

  def new_index
    @recommend_courses = Recommend::Item.where(type: 'Recommend::LiveStudioCourseItem')
    @recommend_teachers = Recommend::Item.where(type: 'Recommend::TeacherItem')
  end

  private
  def set_user
    @user = current_user
  end
end
