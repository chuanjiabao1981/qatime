class GroupsController < ApplicationController
  respond_to :html
  def index
    @groups = Group.all.by_subject(params[:subject]).by_school(params[:school_id]).order(created_at: :asc)
  end


  def show
    @group    = Group.find(params[:id])
    @courses  = Course.all.by_catalogue_id(params[:catalogue_id]).by_group(@group)
  end

end
