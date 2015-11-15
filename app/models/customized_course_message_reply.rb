class CustomizedCourseMessageReply < ActiveRecord::Base

  include QaToken
  include QaActionRecord
  include QaCustomizedCourseActionNotification


  belongs_to :customized_course_message_board,counter_cache: true
  belongs_to :customized_course_message,counter_cache: true
  belongs_to :author,class_name: User
  belongs_to :customized_course

  cattr_accessor    :order_type,:order_column



  validates_presence_of :content,:author



  self.order_type     = :asc
  self.order_column   = :created_at
  self.per_page       = 10

  def operator_id
    self.author_id
  end
end