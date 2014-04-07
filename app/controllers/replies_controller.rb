class RepliesController < ApplicationController
    def create
      @topic = Topic.find_by_id(params[:topic_id])
      @reply = @topic.replies.build(params[:reply].permit!)
      @reply.user_id = current_user.id

      if @reply.save
        redirect_to topic_url(id:@topic.id),notice: "success create reply"
      else
        #render :new
      end
    end

    def destroy

    end
end