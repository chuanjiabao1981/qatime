class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sex, :integer, default: 0
    add_column :users, :birthday, :datetime
    add_column :users, :province, :integer
    add_column :users, :city, :integer
    add_column :users, :description, :text
  end
end
