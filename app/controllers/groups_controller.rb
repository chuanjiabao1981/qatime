class GroupsController < ApplicationController
  respond_to :html
  def index
    @groups = Group.all.order(created_at: :asc)
  end
  def new
    @group = Group.new
  end
  def create
    @group = Group.new(params[:group].permit!)
    @group.city   = @group.teacher.school.city
    @group.school = @group.teacher.school
    @group.save
    respond_with @group
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update_attributes(params[:group].permit!)
    respond_with @group
  end
end
