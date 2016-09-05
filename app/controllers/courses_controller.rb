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

    if @lesson
      @qa_files = @lesson.qa_files.order(created_at: :asc)
    end
    @topics     = get_topics(@lesson)

    render 'lessons/show'
  end

  def node
    @node = Node.find(params[:id])
    @courses = Course.where(node_id: @node.id)
  end

  def schedule_sources
    user = User.find(params[:user_id])
    lessons = user.live_studio_lessons.month(Time.now)
    result = []
    lessons.each do |lesson|
      result << {
        id: lesson.id,
        title: lesson.name,
        url: live_studio.send("#{user.role}_course_path",user,lesson.course.id),
        class: 'evnet-important',
        start: "#{lesson.class_date} #{lesson.start_time}".to_time.to_i*1000,
        end: "#{lesson.class_date} #{lesson.end_time}".to_time.to_i*1000
      }
    end
    render json: {
      success: 1,
      result: result
    }
  end
end