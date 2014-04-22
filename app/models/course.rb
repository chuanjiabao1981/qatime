class Course < ActiveRecord::Base
  belongs_to :teacher    ,:class_name => "User"
  belongs_to :group      ,:counter_cache => true,:inverse_of => :courses
  has_many   :lessons   ,:dependent => :destroy
  has_one    :cover     ,:dependent => :destroy
  has_many   :topics
  validates_presence_of :name,:desc,:group


  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Course.where(token: random_token).size == 0
    end
  end

  def build_lesson(attributes={})
    a         = self.lessons.build(attributes)
    a.teacher = self.teacher
    a.group   = self.group
    a.generate_token if a.token.nil?
    a.build_a_video
    a
  end


  def build_topic(attributes={})
    a             = self.topics.build(attributes)
    a.group       = self.group
    a.generate_token if a.token.nil?
    pictures      = Picture.where(token: a.token)
    a.pictures << pictures unless pictures.empty?
    a
  end
end
