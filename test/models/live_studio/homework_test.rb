require 'test_helper'

module LiveStudio
  class HomeworkTest < ActiveSupport::TestCase
    # 开始时间
    test "homework dispatch to students" do
      group = live_studio_groups(:schedule_published_group1)
      @teacher = group.teacher
      @student_one = users(:student1)
      @student_two = users(:student2)
      @student_three = users(:student_one_with_course)
      task_items = [{ body: '第1题' }, { body: '第2题' }, { body: '第3题' }, { body: '第4题' }, { body: '第5题' }, { body: '第6题' }]
      assert_no_difference "@student_one.live_studio_student_homeworks.count", "作业发放错误" do
        assert_no_difference "@student_two.live_studio_student_homeworks.count", "作业发放错误" do
          assert_difference "@student_three.live_studio_student_homeworks.count", 1, "作业发放错误" do
            assert_difference "@teacher.live_studio_homeworks.count", 1, "作业创建失败" do
              group.homeworks.create(user: @teacher, title: '留个作业试试', task_items_attributes: task_items)
            end
          end
        end
      end
      assert_equal 6, group.reload.homeworks.first.task_items.count, "题目数量不正确"
    end
  end
end
