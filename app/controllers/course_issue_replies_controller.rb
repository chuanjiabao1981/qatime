class CourseIssueRepliesController < ApplicationController
  layout 'application'
  respond_to :html

  def create
    params[:course_issue_reply][:author_id] = current_user.id

    @course_issue_reply = @course_issue.course_issue_replies.build(params[:course_issue_reply].permit!)
    if @course_issue_reply.save
      flash[:success] = "成功发表#{Reply.model_name.human}！"
      @course_issue_reply.notify
      redirect_to course_issue_path(@course_issue)
    else
      @course_issue_replies             = @course_issue.course_issue_replies.order(:created_at).paginate(page: params[:page])
      render 'course_issues/show'
    end
  end

  def edit

  end

  def update
    if @course_issue_reply.update_attributes(params[:course_issue_reply].permit!)
      flash[:success] = "成功修改#{Reply.model_name.human}！"
      redirect_to course_issue_path(@course_issue_reply.course_issue)
    else
      render 'edit'
    end
  end

  def destroy
    @course_issue_reply.destroy
    respond_with @course_issue_reply.course_issue
  end


  def current_resource

    if params[:id]
      @course_issue_reply   = CourseIssueReply.find(params[:id])
      res                   = @course_issue_reply
    end
    if params[:course_issue_id]
      @course_issue         = CourseIssue.find_by_id(params[:course_issue_id])
      res                   = @course_issue
    end

    res
  end
end
