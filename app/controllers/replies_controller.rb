class RepliesController < ApplicationController
    def create
      @topic = Topic.find_by_id(params[:topic_id])
      @reply = @topic.replies.build(params[:reply].permit!)
      @reply.user_id = current_user.id

      respond_to do |format|
        @topic = Topic.find_by_id(params[:topic_id])
        format.html { redirect_to node_topics_url(id:@topic.node_id),notice: "success create reply" }
        format.js
      end
    end

    def destroy

    end
end