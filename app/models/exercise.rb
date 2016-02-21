class Exercise < Examination

  include QaWork
  include QaTemplate::Material

  belongs_to      :customized_tutorial,counter_cache: true
  belongs_to      :customized_course,  counter_cache: true


  belongs_to :homework_publication, class_name: CourseLibrary::HomeworkPublication


  validates_uniqueness_of :homework_publication_id ,scope: :customized_tutorial_id,unless:  "homework_publication_id.nil?"

  has_many        :exercise_solutions,foreign_key: :examination_id,:dependent =>  :destroy  do
    def build(attributes={})
      attributes[:customized_course_id]     = proxy_association.owner.customized_course_id
      attributes[:customized_tutorial_id]   = proxy_association.owner.customized_tutorial_id
      super attributes
    end
  end

  scope :timeout_to_solve ,lambda {|customized_course_id| joins(:customized_tutorial => :customized_course)
                                                             .where(solutions_count:0,customized_tutorials:{customized_course_id: customized_course_id})
                                                             .where("exercises.created_at < ?", 3.day.ago)
                         }

  def response_teachers
    self.customized_course.teachers
  end


end
