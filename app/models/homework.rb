class Homework < Examination

  include QaWork

  belongs_to      :customized_course,counter_cache: true

  has_many        :homework_solutions,foreign_key: :examination_id,:dependent =>  :destroy  do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end
  has_many       :homework_corrections

end
