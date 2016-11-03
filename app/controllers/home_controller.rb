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
    @recommend_courses = Recommend::Item.where(type: 'Recommend::LiveStudioCourseItem').limit(6)
    @recommend_teachers = Recommend::Item.where(type: 'Recommend::TeacherItem').limit(5)
    @user_path = @user.blank? ? signin_path : (!@user.student? && !@user.teacher? && 'javascript:void(0);')
    @questions = Question.all.includes({learning_plan: :teachers},:vip_class,:student).order("created_at desc").limit(4)
    render layout: 'application_front'
  end

  private
  def set_user
    @user = current_user
  end
end
