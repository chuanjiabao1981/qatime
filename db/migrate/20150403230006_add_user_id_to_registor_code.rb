class AddUserIdToRegistorCode < ActiveRecord::Migration
  def change
    remove_column :register_codes,:teacher_id
    remove_column :register_codes,:school_id
    add_column    :register_codes,:user_id,:integer
  end
end
