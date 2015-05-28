class CoursesController < ApplicationController
  respond_to :html
  layout "application"
  include TopicsList

  def show
    @course     = Course.find(params[:id])
    @lesson     = Lesson.find(params[:lesson_id]) if params[:lesson_id]
    unless @lesson
      @lesson   = @course.lessons.order(created_at: :asc).first
    end
    @topics     = get_topics(@lesson)
    render 'lessons/show'
  end

  def node
    @node = Node.find(params[:id])
    @courses = Course.where(node_id: @node.id)
  end

end