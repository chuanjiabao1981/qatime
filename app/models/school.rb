class School < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :city
  validates :name,length:{maximum: 20}
  has_many :teachers,class_name: "User",inverse_of: :school
  belongs_to :city,inverse_of: :schools
end
