class Examination < ActiveRecord::Base

  include ActiveModel::Dirty


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


  state_machine :state, initial: :new do
    transition :new                  => :in_progress,     :on => [:submit]
    transition :in_progress          => :completed,       :on => [:complete]
    transition :new                  => :completed,       :on => [:complete]
    transition :completed            => :in_progress,     :on => [:redo]

    after_transition do |examination,transition|
      puts transition.from
      puts transition.to
      puts transition.event
    end
  end

  def operator_id
    self.teacher_id
  end
end
