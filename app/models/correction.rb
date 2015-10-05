class Correction < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include Tally

  belongs_to  :teacher
  belongs_to  :solution,counter_cache: true
  belongs_to  :customized_course
  has_many    :pictures,as: :imageable
  has_one     :video,as: :videoable
  has_one     :fee, as:  :feeable
  has_many    :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy

  self.per_page = 5


  def author_id
    self.teacher_id
  end
  def author
    self.teacher
  end


  def notify
    teacher           = self.teacher
    student           = self.solution.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: teacher.view_name,
                            to: student.view_name,
                            mobile: student.mobile,
                            message: "批改了你的#{Solution.model_name.human},请关注,"
    )


  end

end
