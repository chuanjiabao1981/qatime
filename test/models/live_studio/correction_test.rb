require 'test_helper'

module LiveStudio
  class StudentHomeworkTest < ActiveSupport::TestCase
    # 学生提交家庭作业
    test "submit student homework" do
      student_homework = live_studio_tasks(:student_homework_two)

      items = student_homework.task_items.map do |item|
        { parent_id: item.id, body: '做错了' }
      end
      correction = student_homework.build_correction(task_items_attributes: items)
      correction.user = users(:student1)
      assert correction.save, "批改出错"
      assert_equal 4, correction.reload.task_items.count, "批改数量不正确"
      assert student_homework.reload.resolved?, "作业状态不正确"
      assert_includes correction.task_items.map(&:body), '做错了', "批改内容不正确"

      correction = student_homework.correction
      items = correction.task_items.map do |item|
        { id: item.id, parent_id: item.id, body: '做对了' }
      end
      assert correction.update(task_items_attributes: items), "重新批改出错"
      assert_not_includes correction.task_items.map(&:body), '做错了', "重新批改不生效"
    end
  end
end
