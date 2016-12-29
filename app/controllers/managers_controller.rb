class ManagersController < ApplicationController

  def customized_courses
    @customized_courses = @manager.customized_courses.order(:created_at => :asc).paginate(page: params[:page],:per_page => 10)
  end

  def action_records
    @action_records = CustomizedCourseActionRecord.all.order(:created_at => :desc).paginate(page: params[:page])
  end
  def payment

  end

  def waiters
    @waiters = current_resource.waiters.order('id desc').paginate(page: params[:page])
  end

  def sellers
    @sellers = current_resource.sellers.order('id desc').paginate(page: params[:page])
  end

  private
  def current_resource
    @manager = Manager.find(params[:id]) if params[:id]
  end

end
