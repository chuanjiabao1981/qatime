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
  has_many        :solutions



  accepts_nested_attributes_for :qa_files, allow_destroy: true


  scope :by_customized_course_work, lambda {where("type = ? or type = ?", Homework.to_s,Exercise.to_s)}

  def notify
    teacher           = self.teacher
    student           = self.customized_course.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: teacher.view_name,
                            to: student.view_name,
                            mobile: student.mobile,
                            message: "布置了#{self.model_name.human},请及时完成,"
    )


  end
end
