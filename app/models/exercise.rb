class Exercise < Examination

  include QaWork
  belongs_to      :customized_tutorial,counter_cache: true
  belongs_to      :customized_course,  counter_cache: true
  has_many        :solutions,as: :solutionable,:dependent =>  :destroy  do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end

  scope :timeout_to_solve ,lambda {|customized_course_id| joins(:customized_tutorial => :customized_course)
                                                             .where(solutions_count:0,customized_tutorials:{customized_course_id: customized_course_id})
                                                             .where("exercises.created_at < ?", 3.day.ago)
                         }





end
