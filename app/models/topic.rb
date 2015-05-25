class Topic < ActiveRecord::Base

  include QaToken


  belongs_to :author        ,:class_name => "User",:counter_cache => true,:inverse_of => :topics
  belongs_to :course        ,:counter_cache => true,:inverse_of => :topics
  belongs_to :curriculum    ,:counter_cache => true,:inverse_of => :topics
  belongs_to :lesson        ,:counter_cache => true,:inverse_of => :topics
  belongs_to :learning_plan # 如果teacher这个就是空了
  belongs_to :teacher


  has_many :replies,:dependent => :destroy
  has_many :pictures,as: :imageable,:dependent => :destroy

  validates_presence_of :author,:title,:body,:lesson,:course,:curriculum,:author



  def initialize(atrributes={})
    super(atrributes)
    self.generate_token if self.token.nil?
    self.course       = self.lesson.course if self.lesson
    self.curriculum   = self.course.curriculum if self.course
    self.teacher      = self.lesson.teacher if self.lesson
    if self.author and self.author.student?
      self.learning_plan =
          self.author.becomes(Student).select_first_valid_learning_plan(APP_CONSTANT["vip_class_ids"][self.teacher.category][self.teacher.subject])
    end
  end
end
