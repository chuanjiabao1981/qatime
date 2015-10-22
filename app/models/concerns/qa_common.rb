module QaCommon
  extend ActiveSupport::Concern
  included do

    scope :by_student     ,lambda{|student| where(student_id:student.id).order(created_at: :desc)}
    scope :by_teacher     ,lambda{|teacher| where(teacher_id:teacher.id)}

    scope :by_author_id   ,lambda{|author_id| where(author_id: author_id)}

    scope :by_teacher_id  ,lambda {|t| where(teacher_id: t) if t}

    scope :by_customized_course_id,
          lambda{|customized_course_id| where(customized_course_id: customized_course_id)}


    def set_customized_course_prices(attributes, customized_course_id)
      customized_course = CustomizedCourse.find(customized_course_id)

      if customized_course
        attributes[:price] = customized_course.price
        attributes[:teacher_price] = customized_course.teacher_price
      end

      attributes
    end

  end
end