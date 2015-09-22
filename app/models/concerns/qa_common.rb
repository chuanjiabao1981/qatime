module QaCommon
  extend ActiveSupport::Concern
  included do

    scope :by_student ,lambda{|student| where(student_id:student.id).order(created_at: :desc)}
    scope :by_teacher ,lambda{|teacher| where(teacher_id:teacher.id).order(created_at: :desc)}
  end
end