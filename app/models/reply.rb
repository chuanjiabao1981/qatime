class Reply < ActiveRecord::Base


  include QaToken
  include ContentValidate

  self.per_page = 10

  belongs_to :topic  ,:counter_cache => true,:inverse_of => :replies
  belongs_to :author, :class_name => "User",:counter_cache => true,:inverse_of => :replies

  has_many :pictures,as: :imageable

  validates_presence_of :author,:topic

   def initialize(atrributes={})
    super(atrributes)
    self.generate_token if self.token.nil?
    self
  end
end