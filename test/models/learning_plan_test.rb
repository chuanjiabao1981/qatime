require 'test_helper'

class LearningPlanTest < ActiveSupport::TestCase
  test "the truth" do
    a = learning_plans(:h_math_learning_plan)
    assert a.valid?
    assert a.teachers.length == 2
  end

  test "physics learning plan valid" do
    a = learning_plans(:h_physics_learning_plan)
    assert a.valid?
    assert a.teachers.length == 1
  end

  test "create new learning plan for new vip class" do
    # 对于一门课从来没有创建过learning plan
    student1              = Student.find(users(:student1).id)

    biology_vip_class     = vip_classes(:h_biology_vip_class)
    learning_plan         = student1.learning_plans.build(vip_class_id: biology_vip_class.id,duration_type: '一个月')

    learning_plan.valid?
    puts learning_plan.errors.full_messages

  end
end
