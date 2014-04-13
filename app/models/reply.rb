class Reply < ActiveRecord::Base

  self.per_page = 10

  belongs_to :topic,:counter_cache => true,:inverse_of => :replies
  belongs_to :user, :counter_cache => true,:inverse_of => :replies
  has_many :pictures,as: :imageable,:dependent => :destroy

  validates_presence_of :user,:topic,:body

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Reply.where(token: random_token).size == 0
    end
  end

  def self.new_with_token(params=nil)
    a = Reply.new(params)
    a.generate_token if a.token.nil?
    pictures      = Picture.where(token: a.token)
    a.pictures << pictures unless pictures.empty?
    a
  end
end