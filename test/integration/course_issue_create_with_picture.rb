require 'test_helper'

require 'content_input_helper'



class CourseIssueCreatePicture  < ActionDispatch::IntegrationTest

  include ContentInputHelper

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
    assert_difference 'Topic.count',1 do
      assert_difference 'CourseIssue.count',1 do
        assert_difference 'Picture.where(imageable_type:"Topic").count',1 do
          assert_difference 'Picture.where(imageable_type:"CourseIssue").count',0 do
            fill_in :course_issue_title,with: '这个长度不能少10的啊啊啊aaaaa'
            set_content('这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321')
            add_a_picture
            click_on "新增#{CourseIssue.model_name.human}"
            t1 = Topic.all.order(created_at: :desc).first
            t2 = CourseIssue.all.order(created_at: :desc).first
            p = Picture.where(imageable_type: "Topic").order(created_at: :desc).first
            assert t1.picture_ids.include?(p.id)
            assert t2.picture_ids.include?(p.id)
          end
        end
      end
    end
    page.save_screenshot('screenshot.png')

    logout_as(student)

  end
end