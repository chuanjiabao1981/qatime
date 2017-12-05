class CreateExamCategories < ActiveRecord::Migration
  def change
    create_table :exam_categories do |t|
      t.string :name
      t.text :description
      t.integer :read_time
      t.integer :play_times
      t.integer :interval_time
      t.integer :waiting_time
      t.integer :total_time
      t.integer :topics_count
      t.integer :total_score
      t.string :type

      t.timestamps null: false
    end
  end
end
