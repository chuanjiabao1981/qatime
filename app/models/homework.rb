class Homework < Examination

  include QaWork

  belongs_to      :customized_course,counter_cache: true

  has_many        :solutions,as: :solutionable,:dependent =>  :destroy  do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end

  def notify
    teacher           = self.teacher
    student           = self.customized_course.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: teacher.view_name,
                            to: student.view_name,
                            mobile: student.mobile,
                            message: "布置了#{Homework.model_name.human},请及时完成,"
    )


  end
end
