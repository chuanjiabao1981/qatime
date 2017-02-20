class Workstation < ActiveRecord::Base
  validates_length_of :name, maximum: 20, minimum: 2

  validates_presence_of :name, :manager
  belongs_to :manager, class_name: "Manager"

  has_one :cash_account, as: :owner, class_name: '::Payment::CashAccount'
  belongs_to :city, counter_cache: true
  has_one  :account, as: :accountable
  has_many :customized_courses
  scope :by_manager_id, lambda {|t| where(manager_id: t) if t}

  has_many :live_studio_courses, class_name: LiveStudio::Course

  has_many :waiters
  has_many :sellers
  has_many :teachers

  has_many :invitations, as: :target
  has_many :course_requests, class_name: LiveStudio::CourseRequest # 招生请求，用于审核

  has_many :action_records

  def cash_account!
    cash_account || ::Payment::CashAccount.create(owner: self)
  end

  def city_name
    city.try(:name)
  end

  def self.default
    Workstation.find_or_create_by(email: 'admin@qatime.cn')
  end
end
