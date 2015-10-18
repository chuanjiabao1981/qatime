class Reply < ActiveRecord::Base

  include QaCommon
  include QaToken
  include ContentValidate

  self.per_page = 5

  belongs_to :topic  ,:counter_cache => true,:inverse_of => :replies
  belongs_to :author, :class_name => "User",:counter_cache => true,:inverse_of => :replies


  has_many :pictures,as: :imageable
  has_one  :video,as: :videoable

  validates_presence_of :author,:topic


end