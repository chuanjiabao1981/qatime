class Workstation < ActiveRecord::Base
  has_one :manager
  belongs_to :city
  has_one  :account, as: :accountable
  has_many :customized_courses

  scope :by_manager_id  ,lambda {|t| where(manager_id: t) if t}
end