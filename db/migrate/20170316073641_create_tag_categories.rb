class CreateTagCategories < ActiveRecord::Migration
  def change
    create_table :tag_categories do |t|
      t.string :name
      t.integer :tags_count, default: 0

      t.timestamps null: false
    end
    add_reference :tags, :tag_category, index: true
  end
end
