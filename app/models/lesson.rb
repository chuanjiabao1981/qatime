class Lesson < ActiveRecord::Base
  belongs_to :teacher,:class_name => "User"
  belongs_to :course,:counter_cache => true,:inverse_of =>:lessons
  has_one    :video,:dependent => :destroy
  validates_presence_of :name,:desc,:curriculum

  belongs_to :curriculum, :counter_cache => true, :inverse_of => :lessons


  # need to be deleted
  belongs_to :group
  # end

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


  state_machine :initial => :init do
    transition :init          => :editing,      :on => [:edit]
    transition :editing       => same,          :on => [:edit,:approve,:reject]
    transition :editing       => :reviewing,    :on => [:submit]
    transition :reviewing     => same,          :on => [:submit]
    transition :reviewing     => :editing,      :on => [:edit]
    transition :reviewing     => :published,    :on => [:approve]
    transition :reviewing     => :rejected,     :on => [:reject]
    transition :rejected      => :rejected,     :on => [:reject] # 这个就是为了容错
    transition :rejected      => :reviewing,    :on => [:submit]
    transition :rejected      => :published,    :on => [:approve]
    transition :rejected      => :editing,      :on => [:edit]
    transition :published     => same,          :on => [:approve]
    transition :published     => :rejected,     :on => [:reject]
    transition :published     => :editing,      :on => [:edit]
    transition :published     => :reviewing,    :on => [:submit]
  end

  end
