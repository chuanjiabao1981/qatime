class HomeworkSolution < Solution
  belongs_to :homework,foreign_key: :examination_id
  belongs_to :customized_course

  has_many   :homework_corrections,foreign_key: :solution_id,dependent: :destroy do
      def build(attributes={})
        attributes[:customized_course_id]       = proxy_association.owner.customized_course_id
        attributes[:examination_id]             = proxy_association.owner.homework.id
        super attributes
      end
  end



  def notify
    teacher           = self.homework.teacher
    student           = self.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: student.view_name,
                            to: teacher.view_name,
                            mobile: teacher.mobile,
                            message: "提交了#{HomeworkSolution.model_name.human},请及时#{Correction.model_name.human},"
    )
  end
end