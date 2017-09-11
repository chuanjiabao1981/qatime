require 'test_helper'

module LiveStudio
  class StudentHomeworkTest < ActiveSupport::TestCase
    # 学生提交家庭作业
    test "submit student homework" do
      student_homework = live_studio_tasks(:student_homework_one)

      items = student_homework.homework.task_items.map do |item|
        { parent_id: item.id, body: '我不会' }
      end
      student_homework.update(task_items_attributes: items)
      assert_equal 4, student_homework.reload.task_items.count, "答案数量不正确"
      assert student_homework.submitted?, "作业状态不正确"
    end
  end
end
