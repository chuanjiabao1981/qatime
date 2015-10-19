class RepliesController < ApplicationController

    respond_to :html
    layout 'application'

    def new
      @reply = Reply.new
    end

    def create
      @topic = Topic.find_by_id(params[:topic_id])
      @reply = @topic.replies.build(params[:reply].permit!)
      @reply.author_id = current_user.id
      @topicable = @topicable
      if @reply.save
        flash[:success] = "成功发表回复！"
        # SmsWorker.perform_async(SmsWorker::REPLY_CREATE_NOTIFICATION, id: @reply.id)

        redirect_to topic_path(@topic)
      else
        @replies      = @topic.replies.order(:created_at).paginate(page: params[:page])
        render 'topics/show'
      end

    end

    def edit
      @topic  = @reply.topic
      @topicable = @topic.topicable
    end

    def update
      @topic  = @reply.topic
      @topicable = @topic.topicable
      if @reply.update_attributes(params[:reply].permit!)
        flash[:success] = "成功修改回复！"
        redirect_to topic_path(@topic)
      else
        render 'edit'
      end
    end

    def destroy
      @reply.destroy
      flash[:success] = "成功删除回复！"
      redirect_to topic_path(@reply.topic)
    end
private
  def current_resource

    if params[:id]
      @reply = Reply.find(params[:id])
      res                = @reply
    end
    if params[:topic_id]
      @topic = Topic.find_by_id(params[:topic_id])
      res               = @topic
    end

    res
  end
end