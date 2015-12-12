class AddPriceToEarningRecords < ActiveRecord::Migration
  def change
    add_column :earning_records,:price,:float
    remove_column :earning_records, :percent, :float
  end
end