class CoursesController < ApplicationController
  respond_to :html
  def index
    @courses = Course.all.order(updated_at: :desc)
  end
  def new
    @group            = Group.find(params[:group_id])
    @course           = @group.build_course
  end
  def create
    @group            = Group.find(params[:group_id])
    @course           = @group.build_course(params[:course].permit!)
    @course.save
    respond_with @course
  end
  def show
    @course     = Course.find(params[:id])
    @lesson     = Lesson.find(params[:lesson_id]) if params[:lesson_id]
    unless @lesson
      @lesson   = @course.lessons.order(created_at: :asc).first
    end
  end
  def edit
    @course = Course.find(params[:id])
  end
  def update
    @course = Course.find(params[:id])
    @course.update_attributes(params[:course].permit!)
    respond_with @course
  end

  def node
    @node = Node.find(params[:id])
    @courses = Course.where(node_id: @node.id)
  end
end
