class HomeworksController < ApplicationController
  respond_to :html
  layout "application"
  include QaFilesHelper

  def new
    @homework = Homework.new
  end

  def create
    @homework = @customized_course.homeworks.build(change_params_for_qa_files(params[:homework]).permit!)
    @homework.teacher = current_user
    @homework.student = @customized_course.student
    @homework.save

    if @homework.save
      flash[:success] = "成功创建#{Homework.model_name.human}"
      SmsWorker.perform_async(SmsWorker::HOMEWORK_CREATE_NOTIFICATION, id: @homework.id)
    end
    respond_with @customized_course,@homework
  end

  def show
    @qa_files      = @homework.qa_files.order(:created_at => "ASC")
    @solutions     = @homework.solutions.order(:created_at => "desc").paginate(page: params[:page])

  end

  def edit

  end

  def update
    @homework.update_attributes(change_params_for_qa_files(params[:homework]).permit!)
    respond_with  @homework
  end

  def destroy
    @homework.destroy
    respond_with  @customized_course,@homework
  end

private
  def current_resource
    if params[:customized_course_id]
      @customized_course      = CustomizedCourse.find(params[:customized_course_id])
      r = @customized_course
    end
    if params[:id]
      @homework               = Homework.find(params[:id])
      @customized_course      = @homework.customized_course
      r                       = @homework
    end
    r
  end
end
