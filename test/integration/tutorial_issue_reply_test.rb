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
  end


  private
  def create_page(user,user_session,create_path,redirected_to_path)
    user_session.post create_path,tutorial_issue_reply:{content: random_str}
    user_session.assert_redirected_to redirected_to_path
  end

end
