require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  # def test_answer_create
  #   answer_create do |before_answered_questions_count,after_answered_questions_count|
  #     assert before_answered_questions_count + 1 == after_answered_questions_count
  #   end
  # end
  #
  #
  #
  # def test_answer_create_again
  #   answer_create do |before_answered_questions_count,after_answered_questions_count|
  #     assert before_answered_questions_count + 1 == after_answered_questions_count
  #   end
  #   answer_create  do |before_answered_questions_count,after_answered_questions_count|
  #     assert before_answered_questions_count   == after_answered_questions_count
  #   end
  #
  # end
  #
  # def answer_create(&block)
  #   teacher1 = Teacher.find(users(:teacher1).id)
  #   h_math_learning_plan = learning_plans(:h_math_learning_plan)
  #   student1_question1 = questions(:student1_question1)
  #   teacher1_learning_plan_assignment1 = learning_plan_assignments(:h_math_assignment1)
  #   teacher2_learning_plan_assignment2 = learning_plan_assignments(:h_math_assignment2)
  #   a = teacher1.answers.build(question_id: student1_question1.id,
  #                              content: "123456789012345678900")
  #   a.save
  #
  #
  #   before_learning_plan_answered_questions_count = h_math_learning_plan.answered_questions_count
  #
  #   before_question_answers_count = student1_question1.answers_count
  #   before_teacher1_answered_questions_count = teacher1_learning_plan_assignment1.answered_questions_count
  #   before_teacher2_answered_questions_count = teacher2_learning_plan_assignment2.answered_questions_count
  #
  #
  #   h_math_learning_plan.reload
  #   student1_question1.reload
  #   teacher1_learning_plan_assignment1.reload
  #   teacher2_learning_plan_assignment2.reload
  #
  #   after_learning_plan_answered_questions_count = h_math_learning_plan.answered_questions_count
  #   after_question_answers_count = student1_question1.answers_count
  #   after_teacher1_answered_questions_count = teacher1_learning_plan_assignment1.answered_questions_count
  #   after_teacher2_answered_questions_count = teacher2_learning_plan_assignment2.answered_questions_count
  #
  #   # question的answer+1
  #   assert  before_question_answers_count+1 ==  after_question_answers_count
  #   # 记录了teacher1 解决了此问题
  #   assert student1_question1.answers_info[teacher1.id.to_s]
  #
  #   assert student1_question1.last_answer_info["teacher_id"] == teacher1.id
  #   # 判断 teacher1 解决问题的个数
  #   yield before_teacher1_answered_questions_count , after_teacher1_answered_questions_count,
  #         before_learning_plan_answered_questions_count, after_learning_plan_answered_questions_count
  #   # teacher2未解决此问题
  #   assert before_teacher2_answered_questions_count == after_teacher2_answered_questions_count
  # end
end
