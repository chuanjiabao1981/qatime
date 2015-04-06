class AddUserIdToRegistorCode < ActiveRecord::Migration
  def change
    remove_column :register_codes,:teacher_id,:integer
    remove_column :register_codes,:school_id,:integer
    add_column    :register_codes,:user_id,:integer
  end
end
