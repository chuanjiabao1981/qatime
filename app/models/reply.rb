class Reply < ActiveRecord::Base

  include QaCommon
  include QaToken
  include ContentValidate
  include QaActionRecord
  include QaCustomizedCourseActionNotification



  cattr_accessor    :order_type,:order_column


  belongs_to        :topic  ,:counter_cache => true,:inverse_of => :replies
  belongs_to        :author, :class_name => "User",:counter_cache => true,:inverse_of => :replies



  has_many          :pictures,as: :imageable
  has_one           :video,as: :videoable

  validates_presence_of :author,:topic

  self.order_type     = :asc
  self.order_column   = :created_at
  self.per_page       = 5


  def operator_id
    self.author_id
  end

end