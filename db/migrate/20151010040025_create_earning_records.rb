class CreateEarningRecords < ActiveRecord::Migration
  def change
    create_table :earning_records do |t|
      t.integer :fee_id
      t.integer :account_id
      t.float   :percent
      t.float   :value
      t.timestamps null: false
    end
  end
end
