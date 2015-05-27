class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true,:counter_cache => true,:inverse_of => :comments

  belongs_to :author,class_name: "User"
  validates_presence_of :content
  validates_presence_of :author
end
