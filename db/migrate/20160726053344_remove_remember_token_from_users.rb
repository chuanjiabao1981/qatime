class RemoveRememberTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :remember_token, :string, limit: 128, index: true
  end
end
