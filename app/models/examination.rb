class Examination < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include QaCommon
  include QaWork
  include QaActionRecord
  include QaComment
  include QaCustomizedCourseActionNotification



  belongs_to      :teacher
  belongs_to      :student

  has_many        :qa_files      , -> { order 'created_at asc' },as: :qa_fileable
  has_many        :corrections
  has_many        :solutions



  accepts_nested_attributes_for :qa_files, allow_destroy: true


  scope :by_customized_course_work, lambda {where("type = ? or type = ?", Homework.to_s,Exercise.to_s)}


  def operator_id
    self.teacher_id
  end
end
