require 'test_helper'
class Qatime::StudentHomeworkAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @student = users(:student_one_with_course)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
    @student_token = api_login(@student, :app)
    @group = live_studio_groups(:schedule_published_group1)
  end

  # 学生提交的作业
  test "teacher view student homeworks" do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/student_homeworks", { status: 'submitted' }, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_not_includes @res['data'].map {|item| item['status'] }, 'pending', "返回结果不正确"
    assert_includes @res['data'].map {|item| item['status'] }, 'submitted', "返回结果不正确"
    assert_not_includes @res['data'].map {|item| item['status'] }, 'resolved', "返回结果不正确"
    get "/api/v1/live_studio/students/#{@student.id}/student_homeworks", { status: 'resolved' }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 0, @res['data'].count, "作业数量不正确"
    assert_request_success?
  end

  # 老师查看别人专属课作业
  test 'teacher view other student homeworks' do
    @teacher1 = users(:teacher1)
    @teacher1_token = api_login_by_pc(@teacher1, :teacher_live)
    get "/api/v1/live_studio/teachers/#{@teacher.id}/student_homeworks", {}, 'Remember-Token' => @teacher1_token
    assert_equal 1003, JSON.parse(response.body)['error']['code'], "权限控制失效"
  end

  # 学生查看我的作业
  test 'student view student homeworks' do
    get "/api/v1/live_studio/students/#{@student.id}/student_homeworks", { status: 'pending' }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_includes @res['data'].map {|item| item['status'] }, 'pending', "返回结果不正确"
    assert_not_includes @res['data'].map {|item| item['status'] }, 'submitted', "返回结果不正确"
    assert_not_includes @res['data'].map {|item| item['status'] }, 'resolved', "返回结果不正确"
    get "/api/v1/live_studio/students/#{@student.id}/student_homeworks", { status: 'submitted' }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_not_includes @res['data'].map {|item| item['status'] }, 'pending', "返回结果不正确"
    assert_includes @res['data'].map {|item| item['status'] }, 'submitted', "返回结果不正确"
    assert_not_includes @res['data'].map {|item| item['status'] }, 'resolved', "返回结果不正确"
    get "/api/v1/live_studio/students/#{@student.id}/student_homeworks", { status: 'resolved' }, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 0, @res['data'].count, "作业数量不正确"
  end
end
