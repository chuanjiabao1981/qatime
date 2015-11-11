class CustomizedCourseMessageReply < ActiveRecord::Base

  include QaToken
  include QaActionRecord
  include QaCustomizedCourseActionNotification

  validates_presence_of :content,:author

  belongs_to :customized_course_message_board,counter_cache: true
  belongs_to :customized_course_message,counter_cache: true
  belongs_to :author,class_name: User
  belongs_to :customized_course

  def operator_id
    self.author_id
  end
end