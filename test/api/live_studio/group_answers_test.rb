require 'test_helper'
class Qatime::GroupQuestionsAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 老师添加回答
  test "teacher add answer" do
    @question = live_studio_tasks(:question_one)
    assert_difference "LiveStudio::Answer.count", 1, "回答失败" do
      post "/api/v1/live_studio/questions/#{@question.id}/answers", { body: '我也不会' }, 'Remember-Token' => @teacher_token
    end
    assert @question.reload.resolved?, "问题状态不正确"
    assert_equal "我也不会", @question.answer.body, "回答错误"
  end

  # 老师修改回答
  test "teacher update answer" do
    @question = live_studio_tasks(:question_two)
    @answer = @question.answer

    assert_no_difference "LiveStudio::Answer.count", "修改回答失败" do
      patch "/api/v1/live_studio/answers/#{@answer.id}", { body: '新的回答' }, 'Remember-Token' => @teacher_token
    end
    assert @question.reload.resolved?, "问题状态不正确"
    assert_equal "新的回答", @question.answer.body, "没有正确修改湖底啊"

    @question = live_studio_tasks(:question_three)
    @answer = @question.answer
    assert_no_difference "LiveStudio::Answer.count", "修改回答失败" do
      patch "/api/v1/live_studio/answers/#{@answer.id}", { body: '新的回答' }, 'Remember-Token' => @teacher_token
    end
    assert_request_denied?
  end
end
