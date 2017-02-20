# This migration comes from payment (originally 20170208054505)
class AddFromUserToPaymentBillings < ActiveRecord::Migration
  def change
    add_reference :payment_billings, :from_user, index: true
  end
end


