class Workstation < ApplicationRecord
  validates_length_of :name, maximum: 20, minimum: 2

  validates_presence_of :name, :manager
  belongs_to :manager, class_name: "Manager"

  has_one :cash_account, as: :owner, class_name: '::Payment::CashAccount'
  belongs_to :city
  has_one  :account, as: :accountable
  has_many :customized_courses
  scope :by_manager_id, lambda {|t| where(manager_id: t) if t}

  has_many :live_studio_courses, class_name: LiveStudio::Course

  has_many :waiters
  has_many :sellers
  has_many :teachers

  has_many :invitations, as: :target

  def cash_account!
    cash_account || ::Payment::CashAccount.create(owner: self)
  end
end
