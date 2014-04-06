class ReplyController < ApplicationController
  def new
    @reply = Reply.new
    @node  = Topic.find_by_id(params[:topic_id])
  end

  def create
    @reply = Reply.new(params)
    @reply.user_id = current_user.id
    @reply.save
  end

  def destroy

  end
end