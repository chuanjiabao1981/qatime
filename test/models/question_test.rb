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


    assert question.answers_info[users(:physics_teacher1).id.to_s] == false
    assert question.learning_plan.id != old_learning_plan.id
    assert old_learning_plan.reload.questions_count == old_learning_plan_questions_count - 1
    assert new_learning_plan.reload.questions_count == new_learning_plan_questions_count + 1
    #assert question.learning_plan.questions.size == question.learning_plan.questions_count
  end

  test "question delete" do
    # student1                = Student.find(users(:student1).id)
    # h_physics_vip_class     = vip_classes(:h_physics_vip_class)
    # assert student1.valid?
    #
    # #创建问题
    # question = student1.questions.build(title:"123456789009987",
    #                                     content:"00000000000011111111112222222222",
    #                                     vip_class_id: h_physics_vip_class.id
    #                                   )
    # assert question.valid?
    # question.save
    #
    #
    # learning_plan             = question.learning_plan
    # question_count_before     = learning_plan.reload.questions_count
    #
    # #回答问题
    # teacher                         = learning_plan.teachers.first
    # answer                          = teacher.answers.build(question_id: question.id,content: "123456789012345678900")
    # assert answer.valid?
    # answer.save
    #
    # question.reload
    # answer_question_count_before    = learning_plan.reload.answered_questions_count
    # answer_count_before             = learning_plan.get_the_teacher_assignment(teacher.id).answered_questions_count
    #
    # question.destroy
    #
    # answer_question_count_after     = learning_plan.reload.answered_questions_count
    # question_count_after            = learning_plan.reload.questions_count
    # answer_count_after              = learning_plan.get_the_teacher_assignment(teacher.id).answered_questions_count
    # assert answer_count_before - 1    == answer_count_after
    # assert question_count_before - 1  == question_count_after
    #
    # assert answer_question_count_after +1 ==answer_question_count_before
  end
end
