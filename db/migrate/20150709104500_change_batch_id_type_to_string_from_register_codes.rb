class ChangeBatchIdTypeToStringFromRegisterCodes < ActiveRecord::Migration
  def up
    change_column :register_codes, :batch_id, :string
  end

  def down
    change_column :register_codes, :batch_id, :string
  end
end