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
    student1                    = Student.find(users(:student1).id)

    learning_plan               = add_a_month_learning_plan(student1)
    assert learning_plan.valid?
    # assert Time.zone.now.to_date + 1.month == learning_plan.end_at.to_date
  end

  test "create two learning plan" do
    '''
      这个是为了测试如果一个学生已经有了一个学习计划，连续创建两个学习计划是符合预期的
      初始化的student1 是没有关于biology的学习计划的
    '''
    # student1                      = Student.find(users(:student1).id)
    # # 初始化学习计划
    # learning_plan1                = add_a_month_learning_plan(student1)
    # # 添加一个学习计划
    # learning_plan2                = add_a_month_learning_plan(student1)
    # # 添加一个学习计划
    # learning_plan3                = add_a_month_learning_plan(student1)
    #
    # assert learning_plan2.begin_at == (learning_plan1.end_at + 1.day).beginning_of_day
    # assert learning_plan2.end_at   == learning_plan1.end_at + 1.day + 1.month
    #
    # #puts learning_plan2.begin_at,learning_plan2.end_at
    # #puts learning_plan3.begin_at,learning_plan3.end_at
    #
    # assert learning_plan3.begin_at == (learning_plan2.end_at + 1.day).beginning_of_day
    # assert learning_plan3.end_at   == learning_plan2.end_at + 1.day + 1.month
  end

  test "add a learning plan for student who learning plan is out date" do
    '''
      如果一个学生他的有learning plan 但是已经过期了
      新建一个learning plan 应该是从当前时间开始
    '''
    # student1                      = Student.find(users(:student1).id)
    # out_learning_plan             = add_a_out_date_learning_plan(student1)
    # new_learning_plan             = add_a_month_learning_plan(student1)
    #
    # assert new_learning_plan.begin_at  != out_learning_plan.end_at + 1.day
    # assert new_learning_plan.begin_at.to_date  == Time.zone.now.to_date
    # assert new_learning_plan.end_at.to_date    == Time.zone.now.to_date + 1.month
  end



  private
  def add_a_month_learning_plan(student)
    teacher1                    = Teacher.find(users(:biology_teacher1).id)
    biology_vip_class           = vip_classes(:h_biology_vip_class)
    learning_plan               = student.learning_plans.build(vip_class_id: biology_vip_class.id,duration_type: '一个月')
    learning_plan.teachers      <<  teacher1
    learning_plan.save
    learning_plan
  end

  def add_a_out_date_learning_plan(student)
    teacher1                    = Teacher.find(users(:biology_teacher1).id)
    biology_vip_class           = vip_classes(:h_biology_vip_class)
    learning_plan               = student.learning_plans.build(vip_class_id: biology_vip_class.id,duration_type: '一个月')
    learning_plan.begin_at      = Time.zone.now - 100.day
    learning_plan.end_at        = learning_plan.begin_at + 1.month
    learning_plan.teachers      <<  teacher1
    assert learning_plan.valid?
    learning_plan

  end
end
