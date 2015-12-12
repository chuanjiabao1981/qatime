class ManagersController < ApplicationController

  def customized_courses
    @customized_courses = CustomizedCourse.all.order(:created_at => :asc).paginate(page: params[:page],:per_page => 10)
  end

  def action_records
    @action_records = ActionRecord.all.order(:created_at => :desc).paginate(page: params[:page])
  end
  def payment

  end
  private
  def current_resource
    @manager = Manager.find(params[:id]) if params[:id]
  end

end
