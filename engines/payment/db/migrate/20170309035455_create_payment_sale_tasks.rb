class CreatePaymentSaleTasks < ActiveRecord::Migration
  def change
    create_table :payment_sale_tasks do |t|
      t.references :target, polymorphic: true, index: true
      t.datetime :started_at
      t.integer :period
      t.datetime :ended_at
      t.datetime :closed_at
      t.integer :charge_percentage, default: 0
      t.decimal :target_balance, precision: 12, scale: 2, default: 0.0
      t.boolean :result
      t.decimal :result_balance, precision: 12, scale: 2, default: 0.0
      t.decimal :charge_balance, precision: 12, scale: 2, default: 0.0
      t.decimal :available_balance, precision: 12, scale: 2, default: 0.0
      t.integer :status

      t.timestamps null: false
    end
  end
end
