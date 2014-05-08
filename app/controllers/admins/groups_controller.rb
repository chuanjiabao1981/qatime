class Admins::GroupsController < ApplicationController
  layout "admin_home"
  def new
    @group = Group.new
    if params[:teacher_id]
      @group.teacher_id = params[:teacher_id]
    end
  end

  def create
    @group = Group.new(params[:group].permit!)
    @group.city   = @group.teacher.school.city
    @group.school = @group.teacher.school
    if @group.save
      redirect_to admins_teacher_url(@group.teacher)
    else
      render 'new'
    end
  end
  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group].permit!)
      redirect_to admins_teacher_path(@group.teacher)
    else
      render 'edit'
    end
  end
end
