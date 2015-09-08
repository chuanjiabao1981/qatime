class CreateQaFiles < ActiveRecord::Migration
  def change
    create_table :qa_files do |t|
      t.integer :author_id
      t.integer :qa_fileable_id
      t.string :qa_fileable_type
      t.string :name
      t.string :type
      t.string :token

      t.timestamps null: false
    end
  end
end
