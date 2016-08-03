class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :province_id, :integer, index: true
    add_column :users, :city_id, :integer, index: true
    add_column :users, :gender, :integer, default: 0
    add_column :users, :birthday, :date
  end
end
