require 'test_helper'

require 'topic_test_helper'


class CourseIssueCreatePicture  < ActionDispatch::IntegrationTest

  include TopicTestHelper

  def setup
    @headless           = Headless.new
    @headless.start
    @customized_course = customized_courses(:customized_course1)
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "create with picture" do
    student = users(:student1)
    log_in_as(student)
    visit new_customized_course_course_issue_path(@customized_course)
    topic_create_with_picture "CourseIssue"

    page.save_screenshot('screenshot.png')

    logout_as(student)

  end
end