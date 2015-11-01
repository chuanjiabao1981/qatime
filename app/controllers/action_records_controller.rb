class ActionRecordsController < ApplicationController
  def index
    @action_records = ActionRecord.all.order(:created_at => :desc).paginate(page: params[:page])
  end
end
