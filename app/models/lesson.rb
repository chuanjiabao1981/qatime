class Lesson < ApplicationRecord
  include QaToken

  #attr_accessible :name, :desc, :token, :tags, :qa_files_attributes, :state_event, :teacher_id

  belongs_to :teacher  #,:class_name => "User"
  belongs_to :course,:counter_cache => true,:inverse_of =>:lessons
  belongs_to :curriculum, :counter_cache => true, :inverse_of => :lessons

  has_many   :review_records,:dependent => :destroy
  has_many   :topics        ,as: :topicable,:dependent => :destroy

  has_one    :current_review_record,-> { order 'created_at' }, :class_name => "ReviewRecord"
  has_one    :video,:dependent => :destroy,as: :videoable

  has_many   :qa_files, dependent: :destroy, as: :qa_fileable

  validates_presence_of :name,:desc,:curriculum


  scope :by_state,    lambda {|s| where(state: s) if s}
  scope :by_teacher,  lambda {|s| where(teacher_id: s) if s}



  accepts_nested_attributes_for :current_review_record
  accepts_nested_attributes_for :qa_files, allow_destroy: true


  # delegate :author_id, to: :teacher


  def author_id
    self.teacher_id
  end
  # def build_a_video
  #   ## 这句是为了如果出错，还能捞回以前的vidoe
  #   ## 考虑创建lesson的时候 视频已经上传，但是由于没有title，再次render new的时候，还是要已近上传的video
  #   ## TODO:: add Test case
  #
  #   self.video =   Video.where(token: self.token).order(created_at: :desc).first
  #   if self.video.nil?
  #     self.build_video
  #     self.video.token = self.token
  #   end
  #   self.video.author_id = self.teacher_id
  #   self.video
  # end



  state_machine :initial => :init do
    transition :init              => :editing,      :on => [:edit]
    transition :init              => :reviewing,    :on => [:submit]
    transition :editing           => same,          :on => [:edit,:approve,:reject]
    transition :editing           => :reviewing,    :on => [:submit]
    transition :reviewing         => same,          :on => [:submit]
    transition :reviewing         => :published,    :on => [:approve]
    transition :reviewing         => :rejected,     :on => [:reject]
    transition :rejected          => same,          :on => [:reject,:edit] # reject -> reject拒绝的时候可能有补充说明???
    transition :rejected          => :reviewing,    :on => [:submit]
    transition :rejected          => :published,    :on => [:approve]
    transition :published         => same,          :on => [:approve]
    transition :published         => :rejected,     :on => [:reject]
    transition :published         => :editing,      :on => [:edit]
    transition :published         => :reviewing,    :on => [:submit]

    before_transition any - :reviewing => :reviewing do |lesson,transition|
      review_record               = lesson.review_records.build
      review_record.start_state   = transition.from
      review_record.save
    end
  end

  end
