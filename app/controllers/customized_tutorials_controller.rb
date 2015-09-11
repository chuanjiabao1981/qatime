class CustomizedTutorialsController < ApplicationController
  layout "application"
  respond_to :html


  include TopicsList
  include QaFilesHelper


  def index
    @customized_tutorials = @customized_course.customized_tutorials.order(created_at: :asc)
  end

  def new
    @customized_tutorial = @customized_course.customized_tutorials.build
  end

  def create
    @customized_tutorial = @customized_course.customized_tutorials.build(change_params_for_qa_files(params[:customized_tutorial]).permit!)
    @customized_tutorial.teacher_id = current_user.id

    if @customized_tutorial.save
      flash[:success] = "成功创建#{CustomizedTutorial.model_name.human}"
      SmsWorker.perform_async(SmsWorker::TUTORIAL_CREATE_NOTIFICATION, id: @customized_tutorial.id)
    end
    respond_with @customized_tutorial
  end

  def edit
  end

  def update
    @customized_tutorial.update_attributes(change_params_for_qa_files(params[:customized_tutorial]).permit!)
    respond_with @customized_tutorial
  end

  def show
    @topics     = get_topics(@customized_tutorial)
    @qa_files   = @customized_tutorial.qa_files.order(:created_at => "ASC")
  end

  private
  def current_resource
    if params[:customized_course_id]
      @customized_course = CustomizedCourse.find(params[:customized_course_id])
      res                = @customized_course
    end
    if params[:id]
      @customized_tutorial = CustomizedTutorial.find(params[:id])
      @customized_course   = @customized_tutorial.customized_course
      res                  = @customized_tutorial
    end
    res
  end
end
