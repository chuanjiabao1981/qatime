class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  include QaHandle
  include QaCommon



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




  belongs_to :first_handle_author,:class_name => "User"
  belongs_to :last_handle_author,:class => "User"
  self.per_page = 10

  def author
    self.student
  end

  def handles_count
    self.corrections_count
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







  def set_handle_infos(correction)
    _set_handle_infos correction
  end
  def update_handle_infos
    _update_handle_infos self.corrections
  end


end
