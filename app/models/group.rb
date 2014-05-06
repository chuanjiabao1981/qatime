class Group < ActiveRecord::Base
  validates_presence_of :name,:teacher
  validates_length_of   :name,maximum: 12
  validates_presence_of :grade,:subject

  belongs_to :teacher #,class_name: "User"
  belongs_to :school
  belongs_to :city

  has_many :courses
  has_many :lessons

  def build_course(attributes={})
    a = self.courses.build(attributes)
    a.teacher = self.teacher
    a
  end
end
