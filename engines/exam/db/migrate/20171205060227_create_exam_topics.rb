class CreateExamTopics < ActiveRecord::Migration
  def change
    create_table :exam_topics do |t|
      t.belongs_to :paper, index: true
      t.belongs_to :category, index: true
      t.belongs_to :package_topic, index: true
      t.belongs_to :group_topic, index: true
      t.string :name
      t.string :section_name
      t.string :title
      t.string :attach
      t.integer :topics_count, default: 1
      t.integer :duration
      t.integer :score
      t.integer :read_time, default: 0
      t.integer :play_times, default: 0
      t.integer :interval_time, default: 0
      t.integer :waiting_time, default: 0
      t.string :answer
      t.string :answer_attach
      t.string :type
      t.integer :status, default: 0
      t.integer :pos, default: 0

      t.timestamps null: false
    end
  end
end
