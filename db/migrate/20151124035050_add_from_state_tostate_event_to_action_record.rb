class AddFromStateTostateEventToActionRecord < ActiveRecord::Migration
  def change
    add_column :action_records,:from,:string
    add_column :action_records,:to,:string
    add_column :action_records,:event,:string
    # add_column :action_records,:stateactionable_type,:string
    # add_column :action_records,:stateactionable_id,:integer
  end
end
