class Lesson < ActiveRecord::Base
  belongs_to :teacher,:class_name => "User"
  belongs_to :course,:counter_cache => true,:inverse_of =>:lessons
  belongs_to :group
  has_one    :video,:dependent => :destroy
  validates_presence_of :name,:desc

  def build_a_video
    self.video =   Video.where(token: self.token).order(created_at: :desc).first
    if self.video.nil?
      self.build_video
      self.video.token = self.token
    end
    self.video
  end
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Lesson.where(token: random_token).size == 0
    end
  end

end
