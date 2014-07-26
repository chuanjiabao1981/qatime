class CreateGroupTypes < ActiveRecord::Migration
  def change
    create_table :group_types do |t|
      t.string :name
      t.string :grade
      t.string :subject
      t.timestamps
    end
  end
end
