class GroupsController < ApplicationController
  respond_to :html
  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end
  def create
    @group = Group.new(params[:group].permit!)
    @group.save
    respond_with @group
  end

  def show
    @group = Group.find(params[:id])
  end
end
