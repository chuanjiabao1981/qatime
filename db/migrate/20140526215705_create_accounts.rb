class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :student
      t.integer :money,:default => 0
      t.integer :lock_version,:default =>0
      t.timestamps
    end
  end
end
