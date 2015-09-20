class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  belongs_to      :student
  belongs_to      :solutionable,polymorphic: true,:counter_cache=>true

  has_many        :pictures,as: :imageable,:dependent => :destroy
  has_many        :corrections,:dependent => :destroy
  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy
  has_many        :qa_files, as: :qa_fileable, :dependent => :destroy
  accepts_nested_attributes_for :qa_files, allow_destroy: true

  def notify
    teacher           = self.solutionable.teacher
    student           = self.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: student.name,
                            to: teacher.name,
                            mobile: student.mobile,
                            message: "提交了#{Solution.model_name.human},请及时#{Correction.model_name.human},"
                           )


  end

end
