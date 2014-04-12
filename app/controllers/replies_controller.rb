class RepliesController < ApplicationController

    def new
      @reply = Reply.new_with_token
    end

    def create
      @topic = Topic.find_by_id(params[:topic_id])
      @reply = Reply.new_with_token(params[:reply].permit!)
      @reply.topic = @topic
      @reply.user_id = current_user.id

      @reply.save
      respond_to do |format|
        @topic = Topic.find_by_id(params[:topic_id])
        format.html { redirect_to node_topics_url(id:@topic.node_id),notice: "success create reply" }
        format.js
      end
    end

    def destroy

    end
end