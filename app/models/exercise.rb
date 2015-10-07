class Exercise < ActiveRecord::Base

  self.table_name = "homeworks"

  default_scope {where("work_type='exercise'")}


  include QaToken
  include ContentValidate
  include QaSolution
  include QaCommon
  include QaWork


  scope :timeout_to_solve ,lambda {|customized_course_id| joins(:customized_tutorial => :customized_course)
                                                             .where(solutions_count:0,customized_tutorials:{customized_course_id: customized_course_id})
                                                             .where("exercises.created_at < ?", 3.day.ago)
                         }


  def initialize(attributes = {})
    attributes[:work_type] = :exercise
    super attributes
  end
  def notify
    teacher           = self.teacher
    student           = self.customized_tutorial.customized_course.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: teacher.view_name,
                            to: student.view_name,
                            mobile: student.mobile,
                            message: "布置了#{Exercise.model_name.human},请及时完成,"
    )


  end

end
