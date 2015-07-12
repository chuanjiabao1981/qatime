class CustomizedTutorial < ActiveRecord::Base

  include QaToken

  belongs_to :teacher
  belongs_to :customized_course

  has_one    :video,:dependent => :destroy,as: :videoable

  validates_presence_of :title,:customized_course,:teacher



  def initialize(attributes = {})
    super(attributes)
    self.generate_token if  self.token == nil or self.token.empty?
  end

  def author_id
    self.teacher_id
  end
end
