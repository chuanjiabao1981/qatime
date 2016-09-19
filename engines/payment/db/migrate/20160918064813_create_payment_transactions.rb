class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2
      t.string :transaction_no, limit: 64
      t.string :remote_ip, limit: 64
      t.integer :pay_type, limit: 4
      t.integer :status, limit: 4
      t.string :source, limit: 64
      t.integer :type, limit: 64

      t.timestamps null: false
    end
  end
end
