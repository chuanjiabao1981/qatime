class Correction < ActiveRecord::Base

  include QaCommon
  include QaToken
  include ContentValidate

  belongs_to        :teacher
  belongs_to        :solution,counter_cache: true
  belongs_to        :examination,counter_cache: true

  has_one           :video,as: :videoable
  has_one           :fee, as:  :feeable

  has_many          :pictures,as: :imageable
  has_many          :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy

  validates         :content, length: {minimum: 5},on: :create

  cattr_accessor    :order_type,:order_column

  after_save        :__after_save
  after_destroy     :__after_destroy

  self.per_page       = 5
  self.order_type     = :desc
  self.order_column   = :created_at


  def author_id
    self.teacher_id
  end
  def author
    self.teacher
  end


  def solution_name
    Solution.model_name.human
  end

  def operator_id
    self.teacher_id
  end

  def notify
    teacher           = self.teacher
    student           = self.solution.student

    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: teacher.view_name,
                            to: student.view_name,
                            mobile: student.mobile,
                            message: "批改了你的#{solution_name},请关注,"
    )
  end

  private
  def __after_save
    self.solution.set_handle_infos(self)
  end

  def __after_destroy
    self.solution.update_handle_infos
  end



end
