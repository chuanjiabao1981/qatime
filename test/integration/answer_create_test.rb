require 'test_helper'

require 'sidekiq/testing'
Sidekiq::Testing.inline!


class AnswerCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    #@headless.destroy
    Capybara.use_default_driver
  end
  test "answer question" do

    teacher1            = users(:teacher1)
    student1_question1  = questions(:student1_question1)
    log_in_as(teacher1)

    visit questions_path
    click_on student1_question1.title



    assert_difference 'Answer.count',1 do
      assert_difference 'Video.where(videoable_type:"Answer").count',1 do
        content = random_str
        # 写回复正文
        find('div.note-editable').set(content)
        # # 准备上传视频
        # find("div.note-group.btn-group").click
        # attach_file("teaching-video-file","#{Rails.root}/test/integration/test.mp4")
        # #视频上传
        # click_button '视频上传'
        # # 等待视频上传
        # # TODO:: 这里可以优化看progress的进度
        sleep 10

        click_on '添加视频'
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

        click_on '提交讲解'

        v = Video.where(videoable_type: "Answer").order(created_at: :desc).first
        # puts Video.where(videoable_type: "Answer").count
        # puts v.to_json
        sleep 3
        page.save_screenshot('screenshot.png')
        #puts page.html
        a = Answer.all.order(created_at: :desc).first
        assert_not a.video.nil?
        assert page.has_content? content
        #assert page.has_xpath?("//video[contains(@src,\"#{a.video.name}\")]",:visible => :all),"no video url"
      end

    end


  end
end
