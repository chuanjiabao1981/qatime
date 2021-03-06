class CustomizedTutorialsController < ApplicationController
  layout "application"
  respond_to :html

  include TopicsList

  include QaCommonFilter
  __add_last_operator_to_param(:customized_tutorial)

  def index
    @customized_tutorials = @customized_course.customized_tutorials.order(created_at: :asc)
  end

  def new
    @customized_tutorial = @customized_course.customized_tutorials.build
  end

  def create
    @customized_tutorial = @customized_course.customized_tutorials.build(params[:customized_tutorial].permit!)
    @customized_tutorial.teacher_id = current_user.id

    if @customized_tutorial.save
      flash[:success] = "成功创建#{CustomizedTutorial.model_name.human}"
    end
    respond_with @customized_tutorial
  end

  def edit
  end

  def update
    @customized_tutorial.update_attributes(params[:customized_tutorial].permit!)
    respond_with @customized_tutorial
  end

  def show
    @topics     = get_topics(@customized_tutorial)
    @tutorial_issues = @customized_tutorial.tutorial_issues.order(created_at: :desc).paginate(page: params[:page])
  end

  def destroy
    @customized_tutorial.destroy
    respond_with @customized_course
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
