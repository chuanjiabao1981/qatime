require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class TutorialIssueReplyIntegrateTest < LoginTestBase
  self.use_transactional_tests = true

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

  test 'show page' do
    show_path           = tutorial_issue_reply_path(@tutorial_issue_reply)
    redirected_to_path  = tutorial_issue_path(@tutorial_issue_reply.tutorial_issue,page:1,
                                              tutorial_issue_reply_animate:@tutorial_issue_reply.id,
                                              anchor:"tutorial_issue_reply_#{@tutorial_issue_reply.id}")
    show_page(@teacher,@teacher_session,show_path,redirected_to_path)
    show_page(@student,@student_session,show_path,redirected_to_path)
  end

  private
  def show_page(user,user_session,show_path,redirected_to_path)
    user_session.get show_path
    user_session.assert_redirected_to redirected_to_path

  end
  def create_page(user,user_session,create_path,redirected_to_path)
    content = random_str
    user_session.post create_path, params: { tutorial_issue_reply: { content: content } }
    if user.student?
      return user_session.assert_redirected_to get_home_url(user)
    end

    user_session.assert_redirected_to redirected_to_path, "#{user.id} #{user.role},#{@tutorial_issue.to_json},#{user_session.flash.to_json}"
    user_session.follow_redirect!
    user_session.assert_select 'div',content

  end

end
