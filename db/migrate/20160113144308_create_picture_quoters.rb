class CreatePictureQuoters < ActiveRecord::Migration
  def change
    create_table :picture_quoters do |t|
      t.integer :picture_id
      t.integer :file_quoter_id
      t.string :file_quoter_type

      t.timestamps null: false
    end
  end
end
