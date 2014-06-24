class Group < ActiveRecord::Base
  validates_presence_of :name,:teacher
  validates_length_of   :name,maximum: 12
  validates_presence_of :grade,:subject

  belongs_to :teacher #,class_name: "User"
  belongs_to :school
  belongs_to :city

  has_many :courses
  has_many :lessons
  has_many :students ,->{distinct}, :through => :student_join_group_records
  has_many :student_join_group_records

  scope :by_subject,lambda {|s| where(subject: s) if s}
  scope :by_school,lambda {|s| where(school_id: s) if s}


  
  def build_course(attributes={})
    a = self.courses.build(attributes)
    a.teacher = self.teacher
    a
  end
end