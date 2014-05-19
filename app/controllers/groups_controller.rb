class GroupsController < ApplicationController
  respond_to :html
  def index
    @groups = Group.all.by_subject(params[:subject]).by_school(params[:school_id]).order(created_at: :asc)
  end


  def show
    @group = Group.find(params[:id])
  end

end
