class Fee < ActiveRecord::Base
  belongs_to :customized_course
  belongs_to :feeable, polymorphic: true

  has_many :consumption_records
  has_many :earning_records
end
