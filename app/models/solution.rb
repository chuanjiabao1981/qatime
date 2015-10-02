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

  scope :timeout_to_correct ,lambda {|customized_course_id|
                              where(customized_course_id: customized_course_id)
                                  .where(corrections_count: 0)
                                  .where("created_at <= ?",3.days.ago)
                            }

  belongs_to :first_correction_author,:class_name => "User"
  belongs_to :last_correction_author,:class => "User"
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

  def update_correction_infos(correction)
    if self.first_correction_author.nil?
      self.first_correction_author_id     = correction.author.id
      self.first_correction_created_at    = correction.created_at
    end
    self.last_correction_author_id        = correction.author.id
    self.last_correction_created_at       = correction.created_at
    self.save
  end

end
