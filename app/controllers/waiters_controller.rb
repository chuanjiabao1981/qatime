class WaitersController < ApplicationController

  layout 'waiter_home'
  def customized_courses
    @customized_courses = @waiter.customized_courses.order(:created_at => :asc).paginate(page: params[:page],:per_page => 10)
  end

  private
  def current_resource
    @waiter = Waiter.find(params[:id]) if params[:id]
  end

end
