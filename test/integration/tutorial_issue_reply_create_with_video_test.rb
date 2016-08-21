require 'test_helper'
# require 'content_input_helper'
require 'reply_test_helper'

class TutorialIssueReplyWithVideo  < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = true

  # include ContentInputHelper
  include ReplyTestHelper
  def setup
    @headless = Headless.new
    @headless.start
    @tutorial_issue_one               = topics(:tutorial_issue_one)

    Capybara.current_driver           =  :selenium_chrome
    @teacher1                         =  users(:teacher1)
    @tutorial_issue_reply_one         =  replies(:tutorial_issue_reply_one)
    @tutorial_issue_reply_with_video  =  replies(:tutorial_issue_reply_with_video)
    log_in_as(@teacher1)

  end

  def teardown
    new_logout_as(@teacher1)

    Capybara.use_default_driver
  end

  test "create with media" do
    visit tutorial_issue_path(@tutorial_issue_one)
    reply_create_with_media("TutorialIssueReply")
  end

  test 'edit add a video' do

    assert @tutorial_issue_reply_one.video.nil?
    visit edit_tutorial_issue_reply_path(@tutorial_issue_reply_one)
    # page.save_screenshot('screenshots/screenshot.png')
    edit_add_video(@tutorial_issue_reply_one)
  end

  test 'edit video'do

    visit edit_tutorial_issue_reply_path(@tutorial_issue_reply_with_video)
    edit_change_video(@tutorial_issue_reply_with_video)

  end


end
