class CreateCashAccounts < ActiveRecord::Migration
  def change
    create_table :cash_accounts do |t|
      t.references :owner, polymorphic: true, index: true
      t.decimal :balance, precision: 8, scale: 2, default: 0.0

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
