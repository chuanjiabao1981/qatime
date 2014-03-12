class Topic < ActiveRecord::Base

  belongs_to :user ,:counter_cache => true,:inverse_of => :topics
  belongs_to :node ,:counter_cache => true,:inverse_of => :topics

  has_many :replies,:dependent => :destroy

  validates_presence_of :user,:node,:title,:body
end
