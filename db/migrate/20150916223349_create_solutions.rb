class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string  :title
      t.text    :content
      t.integer :homework_id
      t.integer :student_id
      t.string  :token
      t.integer :corrections_count,:default=>0
      t.timestamps null: false
    end
  end
end
