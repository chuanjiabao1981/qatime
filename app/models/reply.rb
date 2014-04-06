class Reply < ActiveRecord::Base

  belongs_to :topic,:counter_cache => true,:inverse_of => :replies
  belongs_to :user, :counter_cache => true,:inverse_of => :replies

  validates_presence_of :user,:topic,:body
end