class Reply < ApplicationRecord

  include QaCommon
  include QaToken
  include ContentValidate
  include QaCustomizedCourseActionRecord
  include QaComment


  include QaCommonStateUpdateParent
  __update_parent_state_machine_after_create(:topic)



  cattr_accessor    :order_type,:order_column


  belongs_to        :topic  ,:counter_cache => true,:inverse_of => :replies
  belongs_to        :author, :class_name => "User",:counter_cache => true,:inverse_of => :replies
  belongs_to        :last_operator,class_name: User


  validates_presence_of :author,:topic,:last_operator

  self.order_type     = :asc
  self.order_column   = :created_at
  self.per_page       = 5


  def operator_id
    self.author_id
  end

end