class CreateQaFileQuoters < ActiveRecord::Migration
  def change
    create_table :qa_file_quoters do |t|
      t.integer :qa_file_id
      t.integer :file_quoter_id
      t.string :file_quoter_type

      t.timestamps null: false
    end
  end
end
