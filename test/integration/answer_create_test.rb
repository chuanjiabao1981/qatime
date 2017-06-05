require 'test_helper'
require 'content_input_helper'

require 'sidekiq/testing'
Sidekiq::Testing.inline!


class AnswerCreateTest < ActionDispatch::IntegrationTest
  include ContentInputHelper

  def setup

    @student1_question1        = questions(:student1_question1)


    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    #@headless.destroy
    Capybara.use_default_driver
  end
  test "answer question" do

    teacher1                  = users(:teacher1)

    new_log_in_as(teacher1)

    visit questions_path
    click_on @student1_question1.title



    assert_difference 'Answer.count',1 do
      assert_difference 'Video.where(videoable_type:"Answer").count',1 do
        content = random_str
        # 写回复正文
        set_content(content)

        add_a_picture

        click_on '添加视频'
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

        click_on '提交讲解'

        v = Video.where(videoable_type: "Answer").order(created_at: :desc).first
        sleep 3
        page.save_screenshot('screenshots/screenshot.png')
        #puts page.html
        a = Answer.all.order(created_at: :desc).first
        assert_not a.video.nil?
        assert page.has_content? content
        assert_picture a
      end

    end


  end
end
