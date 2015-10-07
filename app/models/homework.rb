class Homework < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include QaSolution
  include QaCommon
  include QaWork

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
