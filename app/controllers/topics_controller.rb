#code:utf-8
class TopicsController < ApplicationController
  def index
    @section_id   = params[:section_id]
    @section_id ||= Section.first!.id
    @topics = Topic.where(section_id:@section_id)
  end
  def new
    @topic = Topic.new_with_token
    @node  = Node.find_by_id(params[:node_id])
    #TODO:: 404页面处理
  end

  def create
    @topic          = Topic.new_with_token(params[:topic].permit!)
    @topic.user_id  = current_user.id
    if @topic.save
      redirect_to node_topics_url(id:@topic.node_id),notice: "success create topic"
    else
      render :new
    end
  end
  def show
    @topic        = Topic.find(params[:id])
    @replies = @topic.replies
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
