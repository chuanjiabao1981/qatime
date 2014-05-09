class GroupsController < ApplicationController
  respond_to :html
  def index
    @groups = Group.all.order(created_at: :asc)
  end


  def show
    @group = Group.find(params[:id])
  end

end
