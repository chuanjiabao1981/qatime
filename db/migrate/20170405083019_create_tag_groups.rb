class CreateTagGroups < ActiveRecord::Migration
  def change
    create_table :tag_groups do |t|
      t.string :name
      t.integer :tags_count

      t.timestamps null: false
    end
  end
end
