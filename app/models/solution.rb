class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  belongs_to      :student
  belongs_to      :solutionable,polymorphic: true,:counter_cache=>true

  has_many        :pictures,as: :imageable
  has_many        :corrections,:dependent => :destroy do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end
  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy
  has_many        :qa_files, as: :qa_fileable
  accepts_nested_attributes_for :qa_files, allow_destroy: true


  self.per_page = 10

  def author
    self.student
  end

  def notify
    teacher           = self.solutionable.teacher
    student           = self.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: student.view_name,
                            to: teacher.view_name,
                            mobile: teacher.mobile,
                            message: "提交了#{Solution.model_name.human},请及时#{Correction.model_name.human},"
                           )


  end

end
