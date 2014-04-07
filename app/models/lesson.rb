class Lesson < ActiveRecord::Base
  belongs_to :author,:class_name => "User"
  belongs_to :node
  belongs_to :section
  belongs_to :course,:counter_cache => true,:inverse_of =>:lessons
  has_one    :video,:dependent => :destroy
  validates_presence_of :name,:desc,:node,:section


  def init
    self.generate_token if self.token.nil?
    self.node    = self.course.node
    self.section = self.course.section
    self.author  = self.course.author
    self.video   = Video.where(token: self.token).order(created_at: :desc).first
    self.init_video
  end

  def init_video
    if self.video.nil?
      self.build_video
      self.video.token = self.token
    end
  end
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Lesson.where(token: random_token).size == 0
    end
  end

end
