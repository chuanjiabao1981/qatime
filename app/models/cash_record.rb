class CashRecord < ActiveRecord::Base
  belongs_to :cash_account
  belongs_to :ref, polymorphic: true
end
