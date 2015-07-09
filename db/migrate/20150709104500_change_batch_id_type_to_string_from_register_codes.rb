class ChangeBatchIdTypeToStringFromRegisterCodes < ActiveRecord::Migration
  def change
    change_column :register_codes, :batch_id, :string
  end
end