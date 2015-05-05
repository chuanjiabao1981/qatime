class CourseStateValidate < ActiveModel::Validator
  def validate(record)
    if record.published?
      if record.lessons_count <=0
        record.errors[:state] = '课程下没有知识点，不可以发布!'
      end
    end
  end
end
class Course < ActiveRecord::Base
  belongs_to :teacher    ,:class_name => "User"
  belongs_to :curriculum      ,:counter_cache => true, :inverse_of => :courses




  has_many   :lessons    ,:dependent => :destroy
  has_many   :topics
  has_many   :students   ,:through => :course_purchase_records
  has_many   :course_purchase_records


  validates_presence_of :name,:desc,:curriculum,:chapter

  validates :desc, length: { minimum: 30 }
  validates :position, numericality: { only_integer: true }



  #need to be deleted
    validates_with CourseStateValidate
  #end




  def can_be_purchased
    self.state == "published"
  end
  def published?
    self.state == "published"
  end
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Course.where(token: random_token).size == 0
    end
  end

  def build_lesson(attributes={})
    a               = self.lessons.build(attributes)
    a.teacher       = self.teacher
    a.curriculum    = self.curriculum
    a.generate_token if a.token.nil?
    a.build_a_video
    a.state_event   = "edit"
    a
  end


  def build_topic(attributes={})
    a             = self.topics.build(attributes)
    a.curriculum  = self.curriculum
    a.generate_token if a.token.nil?
    pictures      = Picture.where(token: a.token)
    a.pictures << pictures unless pictures.empty?
    a
  end

  #def human_state_name
  #  I18n.t("app.course.state.#{self.state}")
  #end
end

