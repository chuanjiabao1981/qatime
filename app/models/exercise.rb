class Exercise < Examination

  include QaWork
  include QaTemplate::Material

  belongs_to      :customized_tutorial,counter_cache: true
  belongs_to      :customized_course,  counter_cache: true
  belongs_to      :template,class_name: CourseLibrary::Homework

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




  def self.create_from_template(customized_tutorial,template)
    exercise = customized_tutorial.exercises.build(customized_course_id: customized_tutorial.customized_course_id,
                                                   teacher_id:  template.course.author_id,
                                                   last_operator_id: template.course.author_id,
                                                   title: template.title,
                                                   content: template.description,
                                                   student_id: customized_tutorial.customized_course.student.id
    )
    exercise.template               = template
    exercise.template_file_ids      = template.qa_file_ids
    exercise.template_picture_ids   = template.picture_ids
    exercise.save
    exercise
  end

  def sync_with_template
    return if self.template.nil?
    self.title                  =   self.template.title
    self.content                =   self.template.description
    self.template_file_ids      =   self.template.qa_file_ids
    self.template_picture_ids   =   self.template.picture_ids
    self.save
  end

  def is_same_with_template?
    diff = []
    template = self.template
    if template.nil?
      diff << "not exsits"
      return false
    end
    if template.title != self.title
      diff << "title"
    end
    if template.description != self.content
      diff << "description"
    end

    if not same_array?(template.picture_ids,self.template_picture_ids)
      diff << "picture"
    end


    if not same_array?(template.qa_file_ids,self.template_file_ids)
      diff << "files"
    end
    if diff.blank?
      return true
    end
    return false
  end

  def is_any_component_charged?
    self.exercise_solutions.each do |es|
      return true if es.is_any_component_charged?
    end
    return false
  end


  private
  def same_array?(a,b)
    a = a || []
    b = b || []
    a.uniq.sort  == b.uniq.sort
  end


end
