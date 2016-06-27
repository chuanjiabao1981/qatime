class RenameCashRecordToChangeRecord < ActiveRecord::Migration
  def change
    rename_table :cash_records, :change_records
  end
end
