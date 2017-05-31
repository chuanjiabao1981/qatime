require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class CourseIssueReplyIntegrateTest < LoginTestBase
  self.use_transactional_tests = true

  def setup
    @course_issue               = topics(:course_issue_one)
    @course_issue_reply_one     = replies(:course_issue_reply_one)

    super
  end




  test 'create page' do
    create_path         = course_issue_course_issue_replies_path(@course_issue)
    redirected_to_path  = course_issue_path(@course_issue)
    create_page(@teacher,@teacher_session,create_path,redirected_to_path)
    create_page(@student,@student_session,create_path,redirected_to_path)
  end
  test 'show page' do
    show_path           = course_issue_reply_path(@course_issue_reply_one)
    redirected_to_path  = course_issue_path(@course_issue_reply_one.course_issue,page:1,
                                            course_issue_reply_animate: @course_issue_reply_one.id,
                                            anchor: "course_issue_reply_#{@course_issue_reply_one.id}")
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
    user_session.post create_path, params: { course_issue_reply: { content: content } }
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_redirected_to redirected_to_path
    user_session.follow_redirect!
    user_session.assert_select 'div', content
  end
end
