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

    generate_download_token
  end

  def node
    @node = Node.find(params[:id])
    @courses = Course.where(node_id: @node.id)
  end

  def generate_download_token
    @download_token = Qiniu::RS.generate_download_token :expires_in => 300,
                                                        :pattern => "qatime.qiniudn.com/uploads/*"
    @download_token
  end
end