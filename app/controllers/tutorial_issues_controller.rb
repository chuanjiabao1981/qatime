class TutorialIssuesController < ApplicationController

  include QaTopic
  layout 'application'
  respond_to :html

  include QaCommonFilter
  __add_last_operator_to_param(:tutorial_issue)

  include QaStateMachine
  __event_actions(TutorialIssue,:tutorial_issue)


  def new
    @tutorial_issue = @customized_tutorial.tutorial_issues.build
  end

  def create
    params[:tutorial_issue][:author_id] = current_user.id
    @tutorial_issue = @customized_tutorial.tutorial_issues.build(params[:tutorial_issue].permit!)
    if @tutorial_issue.save
      flash[:success] ="成功创建#{TutorialIssue.model_name.human}"
    end
    respond_with @customized_tutorial,@tutorial_issue
  end

  def show
    tutorial_issue_show_prepare
    @tutorial_issue_reply              = @tutorial_issue.tutorial_issue_replies.build
  end

  def edit

  end
  def update
    if @tutorial_issue.update_attributes(params[:tutorial_issue].permit!)
      flash[:success]="成功编辑#{TutorialIssue.model_name.human}"
    end
    respond_with @customized_tutorial,@tutorial_issue

  end
  private
  def current_resource
    if params[:customized_tutorial_id]
      r = CustomizedTutorial.find(params[:customized_tutorial_id])
      @customized_tutorial = r
    end

    if params[:id]
      r = TutorialIssue.find(params[:id])
      @tutorial_issue = r
    end
    r
  end
end
