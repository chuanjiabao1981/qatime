require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class QuestionCreateTest < ActionDispatch::IntegrationTest
  test "question create" do
    student1 = users(:student1)
    log_in_as(student1)

    visit questions_path
    click_on '我要提问'
    assert_difference 'Question.count',1 do
      select '数学', from: :question_vip_class_id
      fill_in :question_title,with: '这个长度不能少10的啊啊啊'
      fill_in :question_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
      click_on '新增问题'
      page.has_content? '这个长度不能少10的啊啊啊'
    end
  end


end
