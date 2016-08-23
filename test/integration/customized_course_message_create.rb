require 'test_helper'

require 'content_input_helper'


class CustomizedCourseMessageCreate  < ActionDispatch::IntegrationTest
  include ContentInputHelper


  def setup
    @headless                        = Headless.new
    @headless.start
    @customized_course_message_board = customized_course_message_boards(:customized_course_message_board)
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "create with picture" do
    student = users(:student1)
    log_in_as(student)
    title   = random_str
    content = random_str
    visit new_customized_course_message_board_customized_course_message_path(@customized_course_message_board)

    # puts Picture.where(imageable_type: CustomizedCourseMessage).count
    # puts Picture.count
    assert_difference 'Picture.where(imageable_type: CustomizedCourseMessage).count',1 do
      fill_in "customized_course_message_title",with: title
      set_content content
      add_a_picture
      click_on "新增#{CustomizedCourseMessage.model_name.human}"
      sleep 1
      # puts Picture.where(imageable_type: CustomizedCourseMessage).count
      # puts Picture.count
    end

    new_customized_course_message = CustomizedCourseMessage.all.order(created_at: :desc).first
    assert_picture new_customized_course_message
    page.save_screenshot('screenshots/screenshot.png')

    new_logout_as(student)

  end
end
