class Comment < ActiveRecord::Base

  include QaActionRecord

  belongs_to :commentable, :polymorphic => true,:counter_cache => true,:inverse_of => :comments
  belongs_to :customized_course

  belongs_to :author,class_name: "User"
  validates_presence_of :content
  validates_presence_of :author

  def notify
    begin
      from              = self.author
      to                = self.commentable.try(:author)
      return unless from and to and from.name and to.name and to.mobile
      SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: from.view_name,
                            to: to.view_name,
                            mobile: to.mobile,
                            message: "评论了你的#{self.commentable.model_name.human},请关注,"
      )
    rescue
    end
  end

  def operator_id
    self.author_id
  end

end
