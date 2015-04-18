require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "question is valid " do
    question = questions(:student1_question1)
    question.valid?
    puts question.errors.full_messages
  end


  test "question vip_class change" do
    question = questions(:student1_question1)
    old_learning_plan_id = question.learning_plan_id
    new_vip_class = vip_classes(:h_physics_vip_class)
    question.update_all_infos({vip_class_id: new_vip_class.id})

    assert question.answers_info[users(:physics_teacher1).id.to_s] == false
    assert question.learning_plan_id != old_learning_plan_id
    puts question.learning_plan_id
    puts old_learning_plan_id
  end
end
