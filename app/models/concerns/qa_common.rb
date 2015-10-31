module QaCommon
  extend ActiveSupport::Concern
  included do

    scope :by_student     ,lambda{|student| where(student_id:student.id).order(created_at: :desc)}
    scope :by_teacher     ,lambda{|teacher| where(teacher_id:teacher.id)}

    scope :by_author_id   ,lambda{|author_id| where(author_id: author_id)}

    scope :by_teacher_id  ,lambda {|t| where(teacher_id: t) if t}

    scope :by_customized_course_id,
          lambda{|customized_course_id| where(customized_course_id: customized_course_id)}

<<<<<<< HEAD
=======

    def _page_num(o,options)
      column = options[:by] || :created_at
      order  = options[:order] || :desc
      per    = options[:per] || 10

      operator = (order == :asc ? "<=" : ">=")
      (where("#{column} #{operator} ?", o.send(column)).count.to_f / per).ceil
    end
>>>>>>> qatime-homework-refactory
  end
end