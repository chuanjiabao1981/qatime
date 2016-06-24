class CreateLiveStudioCashAccounts < ActiveRecord::Migration
  def change
    create_table :live_studio_cash_accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :balance, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
