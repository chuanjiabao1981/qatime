class Reply < ActiveRecord::Base


  include QaToken
  include ContentValidate
  include Tally

  self.per_page = 10

  belongs_to :topic  ,:counter_cache => true,:inverse_of => :replies
  belongs_to :author, :class_name => "User",:counter_cache => true,:inverse_of => :replies

  scope :by_teacher, lambda {|t| where(author_id: t) if t}

  belongs_to :customized_course

  has_many :pictures,as: :imageable
  has_one  :video,as: :videoable
  has_one  :fee, as: :feeable

  validates_presence_of :author,:topic

   def initialize(atrributes={})
    super(atrributes)
    self.generate_token if self.token.nil?
    self
  end
end