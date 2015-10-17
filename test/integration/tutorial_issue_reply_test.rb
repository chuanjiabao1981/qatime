require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class TutorialIssueReplyIntegrateTest < LoginTestBase

  def setup
    @tutorial_issue         = topics(:tutorial_issue_one)
    @tutorial_issue_reply   = replies(:tutorial_issue_reply_one)

    assert @tutorial_issue_reply.valid?
    super
  end




  test 'create page' do
    create_path         = tutorial_issue_tutorial_issue_replies_path(@tutorial_issue)
    redirected_to_path  = tutorial_issue_path(@tutorial_issue)
    create_page(@teacher,@teacher_session,create_path,redirected_to_path)
    create_page(@student,@student_session,create_path,redirected_to_path)
  end


  private
  def create_page(user,user_session,create_path,redirected_to_path)
    content = random_str
    user_session.post create_path,tutorial_issue_reply:{content: content}
    user_session.assert_redirected_to redirected_to_path,user.role
    user_session.follow_redirect!
    user_session.assert_select 'div',content

  end

end
