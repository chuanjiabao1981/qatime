class HomeworkSolution < Solution
  belongs_to :homework,foreign_key: :examination_id
  belongs_to :customized_course

  has_many   :homework_corrections,foreign_key: :solution_id,dependent: :destroy do
      def build(attributes={})
        attributes[:customized_course_id]       = proxy_association.owner.customized_course_id
        attributes[:examination_id]             = proxy_association.owner.homework.id
        super attributes
      end
  end

end