class CreateRechargeRecords < ActiveRecord::Migration
  def change
    create_table :recharge_records do |t|
      t.integer :student_id
      t.string  :code
      t.timestamps
    end
    add_column :recharge_codes,:recharge_record_id,:integer
  end
end
