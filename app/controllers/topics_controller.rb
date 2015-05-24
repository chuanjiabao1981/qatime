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
    flash[:success] = "成功创建#{Topic.model_name.human}" if @topic.save
    respond_with @topic
  end
  def show
    @topic        = Topic.find(params[:id])
    @replies      = @topic.replies.paginate(page: params[:page])
    @course       = @topic.course
    @reply        = Reply.new
  end

  def edit
    @topic        = Topic.find(params[:id])
  end
  def update
    @topic        = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic].permit!)
      redirect_to topic_path(@topic),notice:"success edit topic"
    else
      render :edit
    end
  end
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topics_path
  end
  def node
    @node   = Node.find(params[:id])
    @topics = Topic.where(node_id:params[:id])
    render :index
  end
end
