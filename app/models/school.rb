class School < ActiveRecord::Base
  has_many :teachers, class_name: 'Teacher', inverse_of: :school
  has_many :students, class_name: 'Student', inverse_of: :school
  has_many :register_codes
  belongs_to :city, inverse_of: :schools

  validates_presence_of :name, :city
  validates :name, length: { maximum: 20 }
  validates :name, uniqueness: { scope: :city_id }
end
