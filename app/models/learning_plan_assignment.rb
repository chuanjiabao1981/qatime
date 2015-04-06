class LearningPlanAssignment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :learning_plan

  def update_answered_questions_count(question)
    if question.is_first_answered_by_the_teacher?(self.teacher_id)
      self.class.where("id = #{self.id}").update_all("answered_questions_count = answered_questions_count + 1")
    end
  end
end
