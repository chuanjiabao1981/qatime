class ExerciseSolution < Solution


  belongs_to :exercise,foreign_key: :examination_id
  belongs_to :customized_course
  belongs_to :customized_tutorial

  has_many :exercise_corrections,foreign_key: :solution_id do
    def build(attributes={})
        attributes[:customized_course_id]        = proxy_association.owner.customized_course_id
        attributes[:customized_tutorial_id]      = proxy_association.owner.customized_tutorial_id
        attributes[:examination_id]              = proxy_association.owner.exercise.id
        super attributes
    end
  end

end