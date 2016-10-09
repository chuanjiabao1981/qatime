module Payment
  class WithdrawRecord < ActiveRecord::Base
    belongs_to :withdraw,foreign_key: 'payment_transaction_id', class_name: 'Payment::Withdraw'

    enum status: %w(unpaid paid error)
  end
end
