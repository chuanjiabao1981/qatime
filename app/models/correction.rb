class Correction < ApplicationRecord

  include QaCommon
  include QaToken
  include ContentValidate
  include QaCustomizedCourseActionRecord
  include QaComment
  include QaCommonStateUpdateParent
  __update_parent_state_machine_after_create(:solution)

  belongs_to        :teacher
  belongs_to        :solution,counter_cache: true
  belongs_to        :examination,counter_cache: true
  belongs_to        :last_operator,:class_name => "User"

  has_one           :video,as: :videoable
  has_one           :fee, as:  :feeable


  validates               :content, length: {minimum: 1},on: :create
  validates_presence_of   :last_operator
  cattr_accessor          :order_type,:order_column

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
