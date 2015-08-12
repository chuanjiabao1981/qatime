class ManagersController < ApplicationController

  def customized_courses
    @customized_courses = CustomizedCourse.all.paginate(page: params[:page],:per_page => 10)
  end

  private
  def current_resource
    @manager = Manager.find(params[:id]) if params[:id]
  end

end
