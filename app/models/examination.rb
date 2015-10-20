class Examination < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include QaCommon
  include QaWork


  belongs_to      :teacher
  belongs_to      :student

  has_many        :qa_files      , -> { order 'created_at asc' },as: :qa_fileable
  has_many        :pictures,as: :imageable
  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy

  has_many        :corrections




  accepts_nested_attributes_for :qa_files, allow_destroy: true


  scope :by_customized_course_work, lambda {where("type = ? or type = ?", Homework.to_s,Exercise.to_s)}

end
