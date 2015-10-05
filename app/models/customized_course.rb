class CustomizedCourse < ActiveRecord::Base
  belongs_to :student
  has_many :customized_course_assignments,:dependent => :destroy
  has_many :teachers,:through => :customized_course_assignments
  has_many :customized_tutorials,:dependent => :destroy
  has_many :corrections
  has_many :replies
  has_many :fees

  has_many :topics,as: :topicable,:dependent => :destroy do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.id
      super attributes
    end
  end
  has_many :homeworks,:dependent => :destroy
  validates_presence_of :subject,:category,:student

  attr_accessor :s_category,:s_school,:s_subject


  def get_some
    puts "123412341234134"
  end
  # has_many timeout_to_solve_homework, lambda { where(solutions_count: 0)},class_name: "Homework"
  def timeout_to_solve_homeworks
    self.homeworks.where("created_at <?",3.day.ago).where('solutions_count = 0')
  end
  def name
    "#{CustomizedCourse.model_name.human}-#{self.created_at.strftime("%Y-%m-%d")}"
  end

end
