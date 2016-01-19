class Exercise < Examination

  include QaWork
  include QaTemplate::Material

  belongs_to      :customized_tutorial,counter_cache: true
  belongs_to      :customized_course,  counter_cache: true
  belongs_to      :template,class_name: CourseLibrary::Homework

  # has_many        :qa_file_quoters,as: :file_quoter
  # has_many        :template_files,through: :qa_file_quoters,source: :qa_file
  # has_many        :picture_quoters,as: :file_quoter
  # has_many        :template_pictures,through: :picture_quoters,source: :picture


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
