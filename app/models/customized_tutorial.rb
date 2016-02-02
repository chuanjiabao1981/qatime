class CustomizedTutorial < ActiveRecord::Base

  include QaToken
  include QaCommon
  include Tally
  include QaCustomizedCourseActionRecord

  include QaTemplate::Material
  include QaTemplate::Video


  validates_presence_of :title,:customized_course,:teacher,:last_operator
  scope                 :by_teacher, lambda {|t| where(teacher_id: t) if t}


  belongs_to :teacher
  belongs_to :last_operator,class_name: User
  belongs_to :customized_course,:counter_cache => true

  belongs_to :template, class_name: CourseLibrary::Course

  has_one    :video,:dependent => :destroy,as: :videoable
  has_one    :fee, as: :feeable

  has_many   :solutions,as: :solutionable,:dependent =>  :destroy

  # has_one    :video_quoter,as: :file_quoter
  # has_one    :template_video,through: :video_quoter,source: :video


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



  def get_the_exercise_from_template(template_id)
    self.exercises.each do |e|
      if e.template_id == template_id
        return e
      end
    end
  end



end
