class Workstation < ActiveRecord::Base
  belongs_to :manager, :class_name => "Manager"
  belongs_to :city
  has_one  :account, as: :accountable
  has_many :customized_courses
  scope :by_manager_id  ,lambda {|t| where(manager_id: t) if t}
end