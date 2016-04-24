require 'test_helper'

class CustomizedCourseMessagingCreate  < ActionDispatch::IntegrationTest
  def setup
    @headless                        = Headless.new
    @headless.start
    @customized_course       = customized_courses(:customized_course1)
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test 'create create text messaging' do
    student = users(:student1)
    log_in_as(student)
    content = random_str
    visit customized_course_messaging_index_path(@customized_course)
    assert_difference 'Message::Message.count', 1 do
      find('#content-area').set(content)
      click_button '提交'
      sleep 1
    end
  end

  test 'create create image messaging' do
    student = users(:student1)
    log_in_as(student)
    visit customized_course_messaging_index_path(@customized_course)

  end
end
