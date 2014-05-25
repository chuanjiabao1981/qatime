class CoursesController < ApplicationController
  respond_to :html
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

    @download_token = generate_video_download_token
  end

  def node
    @node = Node.find(params[:id])
    @courses = Course.where(node_id: @node.id)
  end

end