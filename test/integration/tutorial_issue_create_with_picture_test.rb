require 'test_helper'

require 'topic_test_helper'


class TutorialIssueCreatePicture  < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = true

  include TopicTestHelper

  def setup
    @headless = Headless.new
    @headless.start
    @customized_tutorial = customized_tutorials(:customized_tutorial1)
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "create with picture" do
    student = users(:student1)
    log_in_as(student)
    visit new_customized_tutorial_tutorial_issue_path(@customized_tutorial)
    topic_create_with_picture "TutorialIssue"

    new_logout_as(student)

  end



end
