class Course < ActiveRecord::Base
  belongs_to :author    ,:class_name => "User"
  belongs_to :node      ,:counter_cache => true,:inverse_of => :courses
  belongs_to :section
  has_many   :lessons   ,:dependent => :destroy
  has_one    :cover     ,:dependent => :destroy
  validates_presence_of :name,:desc,:section,:node


  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Course.where(token: random_token).size == 0
    end
  end
  def self.init(attributes = nil, options = {})
    a = Course.new(attributes,options)
    a.section = a.node.section unless a.node.blank?
    a.generate_token if a.token.nil?
    a.cover = Cover.where(token: a.token).order(created_at: :desc).first
    #Rails.logger.info("!!!!===================="+a.cover.name.big.url) if a.cover and a.cover.name.big.url

    a.build_cover if a.cover.nil?
    a.cover.token = a.token
    a
  end
end
