class CashAccount < ActiveRecord::Base

  belongs_to :owner, polymorphic: true
  has_many :change_records

  validates :owner, presence: true
end
