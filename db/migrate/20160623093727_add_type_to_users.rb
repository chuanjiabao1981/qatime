class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string, limit: 100

    User.find_each do |u|
      u.type = u.role.camelize
      u.save
    end
  end
end
