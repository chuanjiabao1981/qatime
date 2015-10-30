class CustomizedTutorial < ActiveRecord::Base

  include QaToken
  include QaCommon
  include Tally
  include QaActionRecord
  include QaActionNotification


  validates_presence_of :title,:customized_course,:teacher
  scope                 :by_teacher, lambda {|t| where(teacher_id: t) if t}


  belongs_to :teacher
  belongs_to :customized_course,:counter_cache => true

  has_one    :video,:dependent => :destroy,as: :videoable
  has_one    :fee, as: :feeable

  has_many   :solutions,as: :solutionable,:dependent =>  :destroy

  has_many   :tutorial_issues,:dependent => :destroy do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end



  has_many   :exercises,:dependent => :destroy do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes

    end
  end



  self.per_page = 10

  def initialize(attributes = {})
    super(attributes)
    self.generate_token if  self.token == nil or self.token.empty?
  end

  def author
    self.teacher
  end
  def author_id
    self.teacher_id
  end

  def operator_id
    self.teacher_id
  end


  def name
    self.title
  end
end
