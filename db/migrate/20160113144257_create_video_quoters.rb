class CreateVideoQuoters < ActiveRecord::Migration
  def change
    create_table :video_quoters do |t|
      t.integer :video_id
      t.integer :file_quoter_id
      t.string :file_quoter_type

      t.timestamps null: false
    end
  end
end
