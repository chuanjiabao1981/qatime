class Correction < ActiveRecord::Base

  include QaCommon
  include QaToken
  include ContentValidate
  include QaCustomizedCourseActionRecord
  include QaComment
  include QaCustomizedCourseActionNotification



  belongs_to        :teacher
  belongs_to        :solution,counter_cache: true
  belongs_to        :examination,counter_cache: true

  has_one           :video,as: :videoable
  has_one           :fee, as:  :feeable


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


  def operator_id
    self.teacher_id
  end


  private
  def __after_save
    self.solution.set_handle_infos(self)
  end

  def __after_destroy
    self.solution.update_handle_infos
  end



end
