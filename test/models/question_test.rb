require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "question is valid " do
    question = questions(:student1_question1)
    assert question.valid?
    assert question.learning_plan.questions_count == 1
    #learning_plan下question个数是对的
    assert question.learning_plan.questions.size == question.learning_plan.questions_count
  end


  test "question vip_class change" do
    question                            = questions(:student1_question1)
    new_learning_plan                   = learning_plans(:h_physics_learning_plan)
    new_learning_plan_questions_count   = new_learning_plan.questions_count
    old_learning_plan                   = question.learning_plan
    old_learning_plan_questions_count   = old_learning_plan.questions_count
    new_vip_class = vip_classes(:h_physics_vip_class)
    question.update_all_infos({vip_class_id: new_vip_class.id})


    puts question.answers_info
    assert question.answers_info[users(:physics_teacher1).id.to_s] == false
    assert question.learning_plan.id != old_learning_plan.id
    assert old_learning_plan.reload.questions_count == old_learning_plan_questions_count - 1
    assert new_learning_plan.reload.questions_count == new_learning_plan_questions_count + 1
    #assert question.learning_plan.questions.size == question.learning_plan.questions_count
  end
end
