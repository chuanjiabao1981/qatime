class City < ApplicationRecord
  validates_presence_of :name
  validates_length_of :name, maximum: 64, minimum: 2

  has_many :schools, inverse_of: :city, dependent: :destroy
  has_many :workstations

  belongs_to :workstation
  belongs_to :province

  scope :has_default_workstation, -> { where.not(workstation_id: nil) }

  def name_with_province(delimiter = '')
    "#{province.try(:name)}#{delimiter}#{name}"
  end
end
