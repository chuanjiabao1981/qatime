require 'test_helper'
# 个人中心接口
class Qatime::UserQuestionsAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @student = users(:student_one_with_course)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
    @student_token = api_login(@student, :app)
  end

  # 老师查看问题列表
  test "teacher view my questions" do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/questions", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 3, @res['data'].count, "返回提问数量不正确"
    get "/api/v1/live_studio/teachers/#{@teacher.id}/questions", { status: 'pending' }, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 1, @res['data'].count, "待回答返回提问数量不正确"
    get "/api/v1/live_studio/teachers/#{@teacher.id}/questions", { status: 'resolved' }, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 2, @res['data'].count, "已回答提问数量不正确"
  end

  # 学生查看问题列表
  test "student view my questions" do
    get "/api/v1/live_studio/students/#{@student.id}/questions", {}, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 2, @res['data'].count, "返回提问数量不正确"
    get "/api/v1/live_studio/students/#{@student.id}/questions", { status: 'pending' }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 1, @res['data'].count, "待回答返回提问数量不正确"
    get "/api/v1/live_studio/students/#{@student.id}/questions", { status: 'resolved' }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 1, @res['data'].count, "已回答提问数量不正确"
  end
end
