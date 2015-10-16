require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class CourseIssueReplyIntegrateTest < LoginTestBase

  def setup
    @course_issue         = topics(:course_issue_one)

    super
  end




  test 'create page' do
    create_path         = course_issue_course_issue_replies_path(@course_issue)
    redirected_to_path  = course_issue_path(@course_issue)
    create_page(@teacher,@teacher_session,create_path,redirected_to_path)
    create_page(@student,@student_session,create_path,redirected_to_path)
  end


  private
  def create_page(user,user_session,create_path,redirected_to_path)
    content = random_str
    user_session.post create_path,course_issue_reply:{content: content}
    user_session.assert_redirected_to redirected_to_path
    user_session.follow_redirect!
    user_session.assert_select 'div',content

  end

end
