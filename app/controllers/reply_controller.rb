class ReplyController < ApplicationController
  def new
    @reply = Reply.new
    @node  = Topic.find_by_id(params[:topic_id])
  end

  def create
    @reply = Reply.new(params)
    @reply.user_id = current_user.id
    if @reply.save
      @topic = Topic.find_by_id(params[:topic_id])
      redirect_to node_topics_url(id:@topic.node_id),notice: "success create reply"
    else
      render :new
    end

  end

  def destroy

  end
end