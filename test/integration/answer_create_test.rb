require 'test_helper'

class AnswerCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

  end

  def teardown
    @headless.destroy
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
      sleep 20

      click_on '提交讲解'

      page.has_content? '答案是这个样子的，确实是这个样子的字符0987654321009876543210'
      page.has_content? 'iframe'

    end


  end
end
