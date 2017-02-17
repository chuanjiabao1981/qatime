# This migration comes from payment (originally 20170217073914)
class AddTicketToPaymentBillings < ActiveRecord::Migration
  def change
    add_reference :payment_billings, :ticket, polymorphic: true
  end
end
