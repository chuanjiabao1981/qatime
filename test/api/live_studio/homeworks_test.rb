require 'test_helper'
class Qatime::HomeworkAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 学生提交的作业
  test "teacher view homeworks" do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/homeworks", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 3, @res['data'].count, "返回作业数量不正确"
  end
end
