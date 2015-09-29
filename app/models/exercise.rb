class Exercise < ActiveRecord::Base

  include QaToken
  include ContentValidate

  include QaSolution

  include QaCommon



  has_many        :qa_files      , -> { order 'created_at asc' },as: :qa_fileable #, :dependent => :destroy
  has_many        :pictures,as: :imageable#,:dependent => :destroy
  has_many        :solutions,as: :solutionable,:dependent =>  :destroy


  belongs_to      :customized_tutorial,counter_cache: true
  belongs_to      :teacher
  belongs_to      :student
  accepts_nested_attributes_for :qa_files, allow_destroy: true
  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy

  scope timeout_to_solve ,lambda {|customized_course_id| joins(:customized_tutorial => :customized_course)
                                                             .where(solutions_count:0,customized_tutorials:{customized_course_id: customized_course_id})
                                                             .where("exercises.created_at < ?", 3.day.ago)
                         }
  # scope timeout_to_correction
  def author
    self.teacher
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
