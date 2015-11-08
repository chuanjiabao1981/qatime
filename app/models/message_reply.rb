class MessageReply < ActiveRecord::Base

  include QaToken
  include QaActionRecord
  include QaCustomizedCourseActionNotification

  validates_presence_of :content,:author
  belongs_to :message_board,counter_cache: true
  belongs_to :message,counter_cache: true
  belongs_to :author,class_name: User

  def operator_id
    self.author_id
  end
end
