class Correction < ActiveRecord::Base

  include QaCommon
  include QaToken
  include ContentValidate
  include QaCustomizedCourseActionRecord
  include QaComment


  belongs_to        :teacher
  belongs_to        :solution,counter_cache: true
  belongs_to        :examination,counter_cache: true
  belongs_to        :last_operator,:class_name => "User"

  has_one           :video,as: :videoable
  has_one           :fee, as:  :feeable


  validates               :content, length: {minimum: 5},on: :create
  validates_presence_of   :last_operator
  cattr_accessor          :order_type,:order_column

  after_save        :__after_save
  after_destroy     :__after_destroy
  after_create      :__update_solution

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

  def __update_solution
    ##因为只在on create调用,所以solution的last_operator和correction的last_operator相同
    self.solution.update_attributes(last_operator_id: self.last_operator_id,state_event: :handle)
  end



end
