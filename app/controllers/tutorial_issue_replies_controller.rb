class TutorialIssueRepliesController < ApplicationController
  include QaTopic

  respond_to :html
  layout 'application'
  include QaCommonFilter
  __add_last_operator_to_param(:tutorial_issue_reply)


  def create
    params[:tutorial_issue_reply][:author_id] = current_user.id

    @tutorial_issue_reply = @tutorial_issue.tutorial_issue_replies.build(params[:tutorial_issue_reply].permit!)
    if @tutorial_issue_reply.save
      flash[:success] = "成功发表回复！"
      redirect_to tutorial_issue_path(@tutorial_issue)
    else
      tutorial_issue_show_prepare
      render 'tutorial_issues/show'
    end

  end

  def edit

  end

  def show

    @tutorial_issue   =  @tutorial_issue_reply.tutorial_issue
    page_num          =  @tutorial_issue.tutorial_issue_replies.page_num(@tutorial_issue_reply)

    redirect_to tutorial_issue_path(@tutorial_issue,
                                  page: page_num,
                                  tutorial_issue_reply_animate: @tutorial_issue_reply.id,
                                  anchor: "tutorial_issue_reply_#{@tutorial_issue_reply.id}")
  end


  def update
    if @tutorial_issue_reply.update_attributes(params[:tutorial_issue_reply].permit!)
      flash[:success] = "成功修改回复！"
      redirect_to tutorial_issue_path(@tutorial_issue_reply.tutorial_issue)
    else
      render 'edit'
    end
  end

  def destroy
    @tutorial_issue_reply.destroy
    respond_with @tutorial_issue_reply.tutorial_issue
  end


  def current_resource

    if params[:id]
      @tutorial_issue_reply = TutorialIssueReply.find(params[:id])
      res                   = @tutorial_issue_reply
    end
    if params[:tutorial_issue_id]
      @tutorial_issue  = TutorialIssue.find_by_id(params[:tutorial_issue_id])
      res               = @tutorial_issue
    end

    res
  end

end
