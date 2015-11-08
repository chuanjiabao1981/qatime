class Message < ActiveRecord::Base

  include QaToken
  include QaActionRecord
  include QaCustomizedCourseActionNotification

  validates_presence_of :title,:content,:author
  belongs_to :message_board,counter_cache: true
  belongs_to :author,class_name: User
  has_many   :message_replies


  def operator_id
    self.author_id
  end
end
