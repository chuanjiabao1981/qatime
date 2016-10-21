require 'test_helper'

class WelcomeCoursesTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "visit courses view" do
    visit root_path
    click_on '辅导班'
    courses = LiveStudio::Course.first(6)

    courses.each do |course|
      assert page.has_content?(course.name), '辅导班未显示'
    end
  end
end
