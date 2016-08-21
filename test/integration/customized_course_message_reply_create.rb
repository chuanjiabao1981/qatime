require 'test_helper'

require 'content_input_helper'


class CustomizedCourseMessageReplyCreate  < ActionDispatch::IntegrationTest
  include ContentInputHelper


  def setup
    @headless                        = Headless.new
    @headless.start
    @customized_course_message       = customized_course_messages(:customized_course_message1)
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "create with picture" do
    student = users(:student1)
    log_in_as(student)
    content = random_str
    visit customized_course_message_path(@customized_course_message)

    assert_difference 'Picture.where(imageable_type: CustomizedCourseMessageReply).count',1 do
      assert_difference 'CustomizedCourseMessageReply.count',1 do
        set_content content
        add_a_picture
        click_on "新增#{CustomizedCourseMessageReply.model_name.human}"
        sleep 1
      end
    end

    new_customized_course_message_reply = CustomizedCourseMessageReply.all.order(created_at: :desc).first
    assert_picture new_customized_course_message_reply
    assert page.has_content? content
    page.save_screenshot('screenshots/screenshot.png')

    new_logout_as(student)

  end
end
