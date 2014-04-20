#code:utf-8
class TopicsController < ApplicationController
  def index
    @section_id   = params[:section_id]
    @section_id ||= Section.first!.id
    @topics = Topic.where(section_id:@section_id)
  end
  def new
    @course         = Course.find(params[:course_id])
    @topic          = @course.build_topic
    @topic.author   = current_user
  end

  def create
    @course         = Course.find(params[:course_id])
    @topic          = @course.build_topic(params[:topic].permit!)
    @topic.author   = current_user
    if @topic.save
      redirect_to course_path(@course),notice: "success create topic"
    else
      render :new
    end
  end
  def show
    @topic        = Topic.find(params[:id])
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
