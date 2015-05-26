class RepliesController < ApplicationController

    def new
      @reply = Reply.new
    end

    def create
      @topic = Topic.find_by_id(params[:topic_id])
      @reply = Reply.new(params[:reply].permit!)
      @reply.topic = @topic
      @reply.author_id = current_user.id

      if @reply.save
        flash[:success] = "成功发表回复！"
        redirect_to topic_path(@topic)
      else
        render 'new'
      end

    end

    def destroy

    end
end