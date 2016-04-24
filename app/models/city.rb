class City < ActiveRecord::Base
  has_many :schools, inverse_of: :city, dependent: :destroy
  has_many :workstations
  has_many :managers
  validates_presence_of :name
  validates_length_of :name, maximum: 8, minimum: 2
end
