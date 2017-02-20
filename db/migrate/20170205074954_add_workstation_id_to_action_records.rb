class AddWorkstationIdToActionRecords < ActiveRecord::Migration
  def change
    add_reference :action_records, :workstation, index: true
  end
end
