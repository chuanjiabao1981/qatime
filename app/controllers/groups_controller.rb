class GroupsController < ApplicationController
  respond_to :html
  def index
    case current_user.role
      when "admin"
        @groups = Group.by_group_type(params[:group_type]).by_subject(params[:subject]).
            by_school(params[:school_id]).order(created_at: :asc).paginate(page: params[:page],:per_page => 10)
      when "teacher"
        @groups = Group.where(teacher_id: current_user.id).by_group_type(params[:group_type]).
            by_subject(params[:subject]).by_school(params[:school_id]).order(created_at: :asc).paginate(page: params[:page],:per_page => 10)
      when "student"
        @groups = Group.by_group_type(params[:group_type]).by_subject(params[:subject]).
            by_school(params[:school_id]).order(created_at: :asc).paginate(page: params[:page],:per_page => 10)
    end
  end


  def show
    @group    = Group.find(params[:id])
    @courses  = Course.all.by_group(@group).order(group_catalogue_id: :asc,created_at: :asc)
    @catalogue_courses = params[:catalogue_id] == nil ? @courses : @courses.select {|course| course.group_catalogue_id == params[:catalogue_id].to_i}
  end

end