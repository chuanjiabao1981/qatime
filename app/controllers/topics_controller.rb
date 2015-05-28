class TopicsController < ApplicationController
  layout 'application'
  respond_to :html

  def index
    @section_id   = params[:section_id]
    @section_id ||= Section.first!.id
    @topics = Topic.where(section_id:@section_id)
  end
  def new
    @lesson         = Lesson.find(params[:lesson_id])
    @topic          = @lesson.topics.build
    @course         = @lesson.course
  end

  def create
    @lesson         = Lesson.find(params[:lesson_id])
    @topic          = @lesson.topics.build(params[:topic].permit!)
    @topic.author   = current_user

    if @topic.save
      flash[:success] = "成功创建#{Topic.model_name.human}"
      SmsWorker.perform_async(SmsWorker::TOPIC_CREATE_NOTIFICATION, id: @topic.id)
    end
    respond_with @topic
  end
  def show
    @topic        = Topic.find(params[:id])
    @replies      = @topic.replies.order(:created_at).paginate(page: params[:page])
    @course       = @topic.course
    @reply        = Reply.new
  end

  def edit
    @lesson = @topic.lesson
  end
  def update
    @lesson = @topic.lesson
    if @topic.update_attributes(params[:topic].permit!)
      redirect_to topic_path(@topic),notice:"success edit topic"
    else
      render :edit
    end
  end
  def destroy
    @topic.destroy
    flash[:success] = "成功删除#{Topic.model_name.human}!"
    redirect_to lesson_path(@topic.lesson)
  end

  private
  def current_resource
    @topic = Topic.find(params[:id]) if params[:id]
  end
end
