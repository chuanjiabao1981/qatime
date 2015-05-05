class DeleteGroup < ActiveRecord::Migration
  def change
    drop_table :groups
    drop_table :group_catalogues
    drop_table :group_types
    drop_table :student_join_group_records
    remove_column :courses,:group_id,:integer
    remove_column :courses,:group_type_id,:integer
    remove_column :courses,:group_catalogue_id,:integer
    remove_column :lessons,:group_id
  end
end
