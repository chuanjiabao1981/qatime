class AddLoginMobileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_mobile, :string
    add_index :users, :login_mobile, unique: true
  end
end
