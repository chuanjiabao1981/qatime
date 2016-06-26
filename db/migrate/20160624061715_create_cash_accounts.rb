class CreateCashAccounts < ActiveRecord::Migration
  def change
    create_table :cash_accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :balance

      t.timestamps null: false
    end
  end
end
