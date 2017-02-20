class AddTicketToPaymentBillings < ActiveRecord::Migration
  def change
    add_reference :payment_billings, :ticket, polymorphic: true
  end
end
