class ActionRecordsController < ApplicationController
  def index
    @action_records = CustomizedCourseActionRecord.all.order(created_at: :desc).paginate(page: params[:page])
  end
end
