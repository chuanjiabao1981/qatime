require 'test_helper'
class Qatime::GroupHomeworksAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher_with_chat_account)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
    @group = live_studio_groups(:schedule_published_group1)
  end

  # 我布置的作业
  test "teacher get group homeworks" do
    get "/api/v1/live_studio/groups/#{@group.id}/homeworks", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal @group.homeworks.count, @res['data'].size
  end

  test 'teacher add a homework to group' do
    @student_one = users(:student1)
    @student_two = users(:student2)
    @student_three = users(:student_one_with_course)
    task_items = [{ body: '第1题' }, { body: '第2题' }, { body: '第3题' }, { body: '第4题' }, { body: '第5题' }, { body: '第6题' }]
    assert_no_difference "@student_one.live_studio_student_homeworks.count", "作业发放错误" do
      assert_no_difference "@student_two.live_studio_student_homeworks.count", "作业发放错误" do
        assert_difference "@student_three.live_studio_student_homeworks.count", 1, "作业发放错误" do
          assert_difference "@teacher.reload.live_studio_homeworks.count", 1, "作业创建失败" do
            post "/api/v1/live_studio/groups/#{@group.id}/homeworks", { title: '接口创建一个作业', task_items_attributes: task_items.to_json }, 'Remember-Token' => @teacher_token
            assert_request_success?
          end
        end
      end
    end
    homework = LiveStudio::Homework.find(@res['data']['id'])
    assert_equal 6, homework.task_items.count, "题目数量不正确"
    assert_equal 0, homework.tasks_count, "作业提交数量不正确"
  end
end
