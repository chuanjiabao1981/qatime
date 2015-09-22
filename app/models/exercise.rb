class Exercise < ActiveRecord::Base

  include QaToken
  include ContentValidate

  include QaSolution


  has_many        :qa_files      , -> { order 'created_at asc' },as: :qa_fileable #, :dependent => :destroy
  has_many        :solutions,as: :solutionable#,:dependent =>  :destroy
  has_many        :pictures,as: :imageable#,:dependent => :destroy


  belongs_to      :customized_tutorial,counter_cache: true
  belongs_to      :teacher
  accepts_nested_attributes_for :qa_files, allow_destroy: true
  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy


  def author
    self.teacher
  end
  def notify
    teacher           = self.teacher
    student           = self.customized_tutorial.customized_course.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: teacher.name,
                            to: student.name,
                            mobile: student.mobile,
                            message: "布置了#{Exercise.model_name.human},请及时完成,"
    )


  end

end
