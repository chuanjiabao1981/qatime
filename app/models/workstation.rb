class Workstation < ActiveRecord::Base

  validates_length_of :name , maximum: 20,minimum: 2

  validates_presence_of :name, :manager
  belongs_to :manager, :class_name => "Manager"

  has_one :cash_account, as: :owner
  belongs_to :city
  has_one  :account, as: :accountable
  has_many :customized_courses
  scope :by_manager_id  ,lambda {|t| where(manager_id: t) if t}

  has_many :live_studio_courses, class_name: LiveStudio::Course

  has_many :waiters
  has_many :sellers

  def cash_account!
    return cash_account if cash_account.present?
    CashAccount.create(owner: self)
  end
end
