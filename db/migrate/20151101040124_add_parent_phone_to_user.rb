class AddParentPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :parent_phone, :string
  end
end
