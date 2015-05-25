class Reply < ActiveRecord::Base


  include QaToken

  self.per_page = 10

  belongs_to :topic,:counter_cache => true,:inverse_of => :replies
  belongs_to :user, :counter_cache => true,:inverse_of => :replies
  has_many :pictures,as: :imageable

  validates_presence_of :user,:topic,:body

  

  def self.new_with_token(params=nil)
    a = Reply.new(params)
    a.generate_token if a.token.nil?
    pictures      = Picture.where(token: a.token)
    a.pictures << pictures unless pictures.empty?
    a
  end
end