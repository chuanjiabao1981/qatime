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
end
