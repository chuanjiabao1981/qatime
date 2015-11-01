class Comment < ActiveRecord::Base

  include QaActionRecord
  include QaCustomizedCourseActionNotification

  belongs_to :commentable, :polymorphic => true,:counter_cache => true,:inverse_of => :comments
  belongs_to :customized_course

  belongs_to :author,class_name: "User"
  validates_presence_of :content
  validates_presence_of :author


  def operator_id
    self.author_id
  end

end
