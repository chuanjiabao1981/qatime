class Topic < ActiveRecord::Base

  include QaToken
  include ContentValidate


  belongs_to :author        ,:class_name => "User",:counter_cache => true,:inverse_of => :topics
  # begin to delete
  # TODO:: counter处理
  # belongs_to :course        ,:counter_cache => true,:inverse_of => :topics
  # belongs_to :curriculum    ,:counter_cache => true,:inverse_of => :topics
  # end

  belongs_to :topicable     ,:polymorphic   => true        ,:counter_cache => true
  belongs_to :teacher


  has_many :replies,:dependent => :destroy
  has_many :pictures,as: :imageable,:dependent => :destroy

  validates_presence_of :author,:topicable,:author



  def initialize(atrributes={})
    super(atrributes)
    self.generate_token if self.token.nil?
    # self.course       = self.lesson.course if self.lesson
    # self.curriculum   = self.course.curriculum if self.course
    if defined? self.topicable.teacher and self.topicable.teacher
      self.teacher      = self.topicable.teacher
    elsif defined? self.topicable.teachers and self.topicable.teachers.size >= 1
      self.teacher      = self.topicable.teachers.first
    end
    # if self.author and self.author.student?
    #   self.learning_plan =
    #       self.author.becomes(Student).select_first_valid_learning_plan(APP_CONSTANT["vip_class_ids"][self.teacher.category][self.teacher.subject])
    # end
  end
end
