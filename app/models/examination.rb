class Examination < ActiveRecord::Base

  include ActiveModel::Dirty


  include QaToken
  include ContentValidate
  include QaCommon
  include QaWork
  include QaCustomizedCourseActionRecord
  include QaComment
  include QaCommonState

  class ExaminationCompletedValidator < ActiveModel::Validator
    def validate(record)
      if record.solutions_count == 0
        record.errors.add :base , :cant_complete_solutions_zero
      else
        record.solutions.each do |solution|
          if not solution.completed?
            record.errors.add :base , :cant_complete_solutions_not_complete
          end
        end
      end
    end
  end
  __create_state_machine(ExaminationCompletedValidator,nil,true)

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
