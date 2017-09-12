require 'test_helper'
class Qatime::GroupStudentHomeworksAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @student = users(:student_one_with_course)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
    @student_token = api_login(@student, :app)
    @group = live_studio_groups(:schedule_published_group1)
  end

  # 学生提交的作业
  test "teacher get group student homeworks" do
    get "/api/v1/live_studio/groups/#{@group.id}/student_homeworks", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 2, @res['data'].size
  end

  test "teacher get other group student homeworks" do
    @group = live_studio_groups(:published_group1)
    get "/api/v1/live_studio/groups/#{@group.id}/student_homeworks", {}, 'Remember-Token' => @teacher_token
    assert_equal 1003, JSON.parse(response.body)['error']['code'], "权限控制失效"
  end

  # 学生查看我的作业
  test "student get group student homeworks" do
    get "/api/v1/live_studio/groups/#{@group.id}/student_homeworks", {}, 'Remember-Token' => @student_token
    assert_request_success?
    assert_equal 3, @res['data'].size
  end

  # 学生做作业
  test "student update student homework" do
    @student_homework = live_studio_tasks(:pending_student_homework)
    items = @student_homework.homework.task_items.map do |item|
      { parent_id: item.id, body: '我不会' }
    end
    assert_difference "@student_homework.reload.homework.tasks_count", 1, "提交人数没有变化" do
      patch "/api/v1/live_studio/student_homeworks/#{@student_homework.id}", { task_items_attributes: items.to_json }, 'Remember-Token' => @student_token
    end
    assert_request_success?
    assert @student_homework.submitted?, "作业状态不正确"
  end
end
