class Teachers::CoursesController < ApplicationController
  respond_to :html
  def new
    @course           = @group.build_course
  end
  def create
    @course           = @group.build_course(params[:course].permit!)
    @course.save
    respond_with @course
  end

  def edit
  end
  def update
    @course.update_attributes(params[:course].permit!)
    respond_with @course
  end

  private
    def current_resource
      if params[:id]
        @course           = Course.find(params[:id])
        @group            = @course.group
        @course
      elsif params[:group_id]
        @group            = Group.find(params[:group_id])
      end
    end
end
