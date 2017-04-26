class Province < ActiveRecord::Base
  has_many :cities

  scope :has_default_workstation, -> { joins(:cities).where.not(cities: {workstation_id: nil}).distinct }

end
