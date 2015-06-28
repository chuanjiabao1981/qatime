class AddSchoolIdToRegisterCodes < ActiveRecord::Migration
  def change
    add_column :register_codes, :school_id,:integer
  end
end
