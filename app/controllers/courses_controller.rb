class CoursesController < ApplicationController
  respond_to :html
  layout "application"
  def index
    @courses = Course.all.order(updated_at: :desc)
  end

  def show
    @course     = Course.find(params[:id])
    @lesson     = Lesson.find(params[:lesson_id]) if params[:lesson_id]
    @topics     = Topic.where(course_id: @course.id)
    unless @lesson
      @lesson   = @course.lessons.order(created_at: :asc).first
    end

  end

  def node
    @node = Node.find(params[:id])
    @courses = Course.where(node_id: @node.id)
  end

end