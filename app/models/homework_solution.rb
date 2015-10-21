class HomeworkSolution < Solution
  belongs_to :homework,counter_cache: true

  def container
    self.homework
  end


  def notify
    teacher           = self.homework.teacher
    student           = self.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: student.view_name,
                            to: teacher.view_name,
                            mobile: teacher.mobile,
                            message: "提交了#{Solution.model_name.human},请及时#{Correction.model_name.human},"
    )


  end
end