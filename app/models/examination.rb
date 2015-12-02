class Examination < ActiveRecord::Base

  include ActiveModel::Dirty


  include QaToken
  include ContentValidate
  include QaCommon
  include QaWork
  include QaCustomizedCourseActionRecord
  include QaComment
  include QaCommonState

  __create_state_machine(nil)

  validates_presence_of :last_operator




  belongs_to      :teacher
  belongs_to      :student
  belongs_to      :last_operator,:class_name => "User"

  has_many        :qa_files      , -> { order 'created_at asc' },as: :qa_fileable
  has_many        :corrections
  has_many        :solutions



  accepts_nested_attributes_for :qa_files, allow_destroy: true


  scope :by_customized_course_work, lambda {where("type = ? or type = ?", Homework.to_s,Exercise.to_s)}




  def operator_id
    self.teacher_id
  end
end
