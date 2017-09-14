require 'test_helper'
class Qatime::GroupQuestionsAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @student = users(:student_one_with_course)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
    @student_token = api_login(@student, :app)
    @group = live_studio_groups(:schedule_published_group1)
  end

  # 老师查看问题列表
  test "teacher view questions" do
    get "/api/v1/live_studio/groups/#{@group.id}/questions", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 3, @res['data'].count, "返回提问数量不正确"
  end

  # 学生查看问题列表
  test "student view questions" do
    get "/api/v1/live_studio/groups/#{@group.id}/questions", {}, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 3, @res['data'].count, "返回提问数量不正确"
    get "/api/v1/live_studio/groups/#{@group.id}/questions", { user_id: Student.first.id }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 0, @res['data'].count, "用户ID过滤不正确"
    get "/api/v1/live_studio/groups/#{@group.id}/questions", { user_id: @student.id }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 2, @res['data'].count, "我的提问返回数量不正确"
  end

  # 学生提问
  test "student add a question" do
    assert_difference "@group.reload.questions.count", 1, "提问失败" do
      post "/api/v1/live_studio/groups/#{@group.id}/questions", { title: '我再提个问题行吗', body: '问完了' }, 'Remember-Token' => @student_token
    end
    question = @group.questions.first
    assert_equal '我再提个问题行吗', question.title, "提问错误"
    assert question.pending?, "提问状态不正确"

    @group_other = live_studio_groups(:published_group1)
    assert_no_difference "@group.reload.questions.count", "提问权限控制失败" do
      post "/api/v1/live_studio/groups/#{@group_other.id}/questions", { title: '我再提个问题行吗', body: '问完了' }, 'Remember-Token' => @student_token
    end
    assert_request_denied?
  end
end
