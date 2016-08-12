class ChangeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_mobile, :string
  end
end
