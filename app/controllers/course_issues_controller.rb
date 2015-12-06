class CourseIssuesController < ApplicationController
  include QaTopic

  layout 'application'
  respond_to :html

  include QaCommonFilter
  __add_last_operator_to_param(:course_issue)

  def new
    @course_issue = @customized_course.course_issues.build
  end

  def create
    params[:course_issue][:author_id] = current_user.id
    @course_issue                     = @customized_course.course_issues.build(params[:course_issue].permit!)
    if @course_issue.save
      flash[:success] ="成功创建#{CourseIssue.model_name.human}"
    end
    respond_with @customized_course,@course_issue
  end


  def show
    course_issue_show_prepare
    @course_issue_reply      = @course_issue.course_issue_replies.build
  end

  def edit

  end

  def update
    if @course_issue.update_attributes(params[:course_issue].permit!)
      flash[:success]="成功编辑#{CourseIssue.model_name.human}"
    end
    respond_with @customized_course,@course_issue

  end

  def destroy
    @course_issue.destroy
    redirect_to course_issues_customized_course_path(@course_issue.customized_course)
  end

  private
  def current_resource
    if params[:customized_course_id]
      @customized_course = CustomizedCourse.find(params[:customized_course_id])
      r = @customized_course
    end
    if params[:id]
      @course_issue = CourseIssue.find(params[:id])
      r = @course_issue
    end
    r
  end
end
