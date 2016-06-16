class Workstation < ActiveRecord::Base

  validates_length_of :name , maximum: 20,minimum: 2

  validates_presence_of :name, :manager
  belongs_to :manager, :class_name => "Manager"
  belongs_to :city
  has_one  :account, as: :accountable
  has_many :customized_courses
  scope :by_manager_id  ,lambda {|t| where(manager_id: t) if t}

  has_many :live_studio_courses, class_name: LiveStudio::Course

  has_many :waiters
  has_many :sellers
end