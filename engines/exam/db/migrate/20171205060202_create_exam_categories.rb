class CreateExamCategories < ActiveRecord::Migration
  def change
    create_table :exam_categories do |t|
      t.belongs_to :paper, index: true
      t.string :name
      t.text :description
      t.integer :read_time
      t.integer :play_times
      t.integer :interval_time
      t.integer :waiting_time
      t.integer :topics_count, default: 0
      t.integer :duration
      t.integer :score
      t.string :type

      t.timestamps null: false
    end
  end
end
