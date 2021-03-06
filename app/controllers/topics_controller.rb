class TopicsController < ApplicationController
  layout 'application'
  respond_to :html

  include QaCommonFilter
  __add_last_operator_to_param(:topic)


  def index
    @section_id   = params[:section_id]
    @section_id ||= Section.first!.id
    @topics = Topic.where(section_id:@section_id)
  end
  def new
    @topic          = @topicable.topics.build
  end

  def create
    @topic          = @topicable.topics.build(params[:topic].permit!)
    @topic.author   = current_user

    if @topic.save
      flash[:success] = "成功创建#{Topic.model_name.human}"
      # SmsWorker.perform_async(SmsWorker::TOPIC_CREATE_NOTIFICATION, id: @topic.id)
    end
    respond_with @topic
  end
  def show
    @topic        = Topic.find(params[:id])
    @replies      = @topic.replies.order(:created_at=> :desc).paginate(page: params[:page])
    @reply        = Reply.new
  end

  def edit
    @topicable = @topic.topicable
  end
  def update
    @topicable = @topic.topicable
    if @topic.update_attributes(params[:topic].permit!)
      redirect_to topic_path(@topic),notice:"success edit topic"
    else
      render :edit
    end
  end
  def destroy
    @topic.destroy
    flash[:success] = "成功删除#{Topic.model_name.human}!"
    # redirect_to lesson_path(@topic.lesson)
    redirect_to send("#{@topic.topicable.model_name.singular_route_key}_path",@topic.topicable)
  end

  private
  def current_resource
    if params[:lesson_id]
      @topicable         = Lesson.find(params[:lesson_id])
      res                = @topicable
    end
    if params[:customized_tutorial_id]
      @topicable        = CustomizedTutorial.find(params[:customized_tutorial_id])
      res               = @topicable
    end
    if params[:customized_course_id]
      @topicable        = CustomizedCourse.find(params[:customized_course_id])

      res               = @topicable
    end
    if params[:id]
      @topic = Topic.find(params[:id]) if params[:id]
      res    = @topic
    end
    res
  end
end
