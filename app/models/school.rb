class School < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :city
  validates :name,length:{maximum: 20}
  validates :name, uniqueness: {scope: :city_id}

  has_many :teachers,class_name: "User",inverse_of: :school
  has_many :register_codes
  belongs_to :city,inverse_of: :schools
end
