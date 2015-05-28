class RepliesController < ApplicationController

    respond_to :html
    layout 'application'

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
        @replies      = @topic.replies.order(:created_at).paginate(page: params[:page])
        @course       = @topic.course
        render 'topics/show'
      end

    end

    def edit
      @topic  = @reply.topic
      @lesson = @topic.lesson
    end

    def update
      @topic  = @reply.topic
      @lesson = @topic.lesson
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
    @reply = Reply.find(params[:id]) if params[:id]
  end
end