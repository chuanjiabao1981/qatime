class ManagersController < ApplicationController
  def customized_courses
    @customized_courses = begin
      workstation_ids = current_resource.workstations.collect(&:id).uniq
      if workstation_ids
        CustomizedCourse.where(workstation_id: workstation_ids)
      else
        CustomizedCourse.all
      end.order(:created_at).paginate(page: params[:page], per_page: 10)
    end
  end

  def action_records
    @action_records = ActionRecord.all
                                  .order(created_at: :desc)
                                  .paginate(page: params[:page])
  end

  def payment; end

  private

  def current_resource
    @manager = Manager.find(params[:id]) if params[:id]
  end
end
