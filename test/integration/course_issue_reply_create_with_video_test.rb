require 'test_helper'
require 'reply_test_helper'


class CourseIssueReplyWithVideo  < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = true

  include ReplyTestHelper
  def setup
    @headless = Headless.new
    @headless.start
    @course_issue_one                 = topics(:course_issue_one)

    Capybara.current_driver           =  :selenium_chrome
    @teacher1                         =  users(:teacher1)
    @course_issue_reply_one           =  replies(:course_issue_reply_one)
    @course_issue_reply_with_video    =  replies(:course_issue_reply_with_video)
    log_in_as(@teacher1)

  end

  def teardown
    new_logout_as(@teacher1)
    Capybara.use_default_driver
  end

  test "create with media" do
    visit course_issue_path(@course_issue_one)
    reply_create_with_media("CourseIssueReply")
  end

  test 'edit add a video' do
    assert @course_issue_reply_one.video.nil?
    visit edit_course_issue_reply_path(@course_issue_reply_one)
    page.save_screenshot('screenshots/screenshot.png')
    edit_add_video(@course_issue_reply_one)
  end

  test 'edit video'do
    visit edit_course_issue_reply_path(@course_issue_reply_with_video)
    edit_change_video(@course_issue_reply_with_video)
  end
end
