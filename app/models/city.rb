class City < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name , maximum: 8,minimum: 2
  has_many :schools,inverse_of: :city,dependent: :destroy
  has_one :workstation
end
