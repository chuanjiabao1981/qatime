class Tutorial < ActiveRecord::Base
  has_one       :video,:dependent => :destroy
  has_one       :cover,:dependent => :destroy
  belongs_to    :node,:counter_cache => true
  belongs_to    :author,:class_name => "User"

  has_many      :comments,as: :commentable,dependent: :destroy
  validates_presence_of :title,:summary,:node

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Tutorial.where(token: random_token).size == 0
    end
  end
  def self.new_with_find_media(params=nil)
    a       = Tutorial.new(params)
    #tutorial一定会有一个token
    a.generate_token if a.token.nil?
    a.cover = Cover.where(token: a.token).take
    a.video = Video.where(token: a.token).take
    #根据token，如果没有找到则cover和video，则build出来
    a.build_cover if a.cover.nil?
    a.build_video if a.video.nil?
    a
  end
  def build_cover(attributes = {})
    super(attributes.merge({token:self.token}))
  end
  def build_video(attributes={})
    super(attributes.merge({token:self.token}))
  end
end
