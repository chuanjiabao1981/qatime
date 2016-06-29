class ChangeRecord < ActiveRecord::Base
  has_soft_delete

  belongs_to :cash_account
  belongs_to :ref, polymorphic: true
end
