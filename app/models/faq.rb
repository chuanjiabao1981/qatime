class Faq < ApplicationRecord
  belongs_to :user
  belongs_to :faq_topic

  has_many :pictures,as: :imageable,:dependent => :destroy
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Faq.where(token: random_token).size == 0
    end
  end

  def self.new_with_token(params=nil)
    a = Faq.new(params)
    a.generate_token if a.token.nil?
    pictures      = Picture.where(token: a.token)
    a.pictures << pictures unless pictures.empty?
    a
  end
end