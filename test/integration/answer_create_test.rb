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
      # 写回复正文
      find('div.note-editable').set('答案是这个样子的，确实是这个样子的字符0987654321009876543210')
      # 准备上传视频
      find("div.note-group.btn-group").click
      attach_file("teaching-video-file","#{Rails.root}/test/integration/test.mp4")
      #视频上传
      click_button '视频上传'
      # 等待视频上传
      # TODO:: 这里可以优化看progress的进度
      sleep 100

      #page.save_screenshot('screenshot.png')

      click_on '提交讲解'



      page.has_content? '答案是这个样子的，确实是这个样子的字符0987654321009876543210'
      page.has_content? 'iframe'



      # 判断视频和answer以及question进行了关联
      teaching_video =TeachingVideo.order(created_at: :desc).first
      answer = Answer.order(created_at: :desc).first

      assert teaching_video.answer_id     == answer.id
      assert teaching_video.question_id   == answer.question_id

      # 判断是否已经转换完成 因为是inline模式
      assert teaching_video.convert_success?
    end


  end
end
