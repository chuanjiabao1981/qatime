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
    @recommend_courses = Recommend::LiveStudioCourseItem.order(index: :asc).limit(6)
    @recommend_teachers = Recommend::TeacherItem.order(index: :asc).limit(5)
    @user_path = @user.blank? ? signin_path : (!@user.student? && !@user.teacher? && !@user.manager? && 'javascript:void(0);')
    render layout: 'application_front'
  end

  private
  def set_user
    @user = current_user
  end
end
