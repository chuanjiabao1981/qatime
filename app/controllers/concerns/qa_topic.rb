module QaTopic
  extend ActiveSupport::Concern

  def tutorial_issue_show_prepare

    @tutorial_issue_replies  = @tutorial_issue.tutorial_issue_replies
                                   .order(Reply.order_column => Reply.order_type).paginate(page: params[:page])

  end

  def course_issue_show_prepare
    @course_issue_replies    = @course_issue.course_issue_replies
                                   .order(Reply.order_column => Reply.order_type).paginate(page: params[:page])

  end
end