class Course < ActiveRecord::Base
  belongs_to :teacher    #,:class_name => "User"
  belongs_to :curriculum      ,:counter_cache => true, :inverse_of => :courses

  has_many   :lessons    ,-> {order 'created_at'},:dependent => :destroy

  has_many   :students   ,:through => :course_purchase_records
  has_many   :course_purchase_records


  validates_presence_of :name,:desc,:curriculum,:chapter

  validates :desc, length: { minimum: 30 }
  validates :position, numericality: { only_integer: true }

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

  def get_contain_tags_lessons(tags)
    if tags.nil? or tags.empty?
      self.lessons
    else
      a = []
      self.lessons.each do |l|
        if not (l.tags & tags).empty?
          a << l
        end
      end
      a
    end
  end

  def build_lesson(attributes={})
    a               = self.lessons.build(attributes.merge(teacher_id: self.teacher.id))
    a.curriculum    = self.curriculum
    a
  end

end
