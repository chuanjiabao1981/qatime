class Topic < ActiveRecord::Base


  belongs_to :author ,:class_name => "User",:counter_cache => true,:inverse_of => :topics
  ##删除node和section

  belongs_to :course
  belongs_to :curriculum
  has_many :replies,:dependent => :destroy
  has_many :pictures,as: :imageable,:dependent => :destroy

  validates_presence_of :author,:title,:body


  # need to be deleted
    belongs_to :node ,:counter_cache => true,:inverse_of => :topics
    belongs_to :section
    belongs_to :group
  # end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Topic.where(token: random_token).size == 0
    end
  end
  def self.new_with_token(params=nil)
    a = Topic.new(params)
    a.generate_token if a.token.nil?
    pictures      = Picture.where(token: a.token)
    a.section_id  = a.node.section_id if a.node
    a.pictures << pictures unless pictures.empty?
    a
  end
end
