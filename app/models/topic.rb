class Topic < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include QaCommon


  belongs_to :author        ,:class_name => "User",:counter_cache => true,:inverse_of => :topics
  belongs_to :topicable     ,:polymorphic   => true        ,:counter_cache => true
  belongs_to :teacher


  has_many :replies,:dependent => :destroy do
    def build(attribute={})
      if not proxy_association.owner.customized_course_id.nil?
        attribute[:customized_course_id] = proxy_association.owner.customized_course_id
      end
      super attribute
    end
  end
  has_many :pictures,as: :imageable

  #,:dependent => :destroy

  self.per_page = 10

  scope :from_customized_course, lambda {where("customized_course_id is not null").order("created_at desc") }

  validates_presence_of :author


end
