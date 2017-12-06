# This migration comes from exam (originally 20171205060227)
class CreateExamTopics < ActiveRecord::Migration
  def change
    create_table :exam_topics do |t|
      t.belongs_to :paper, index: true
      t.belongs_to :category, index: true
      t.belongs_to :package_topic, index: true
      t.belongs_to :group_topic, index: true
      t.string :name
      t.string :title
      t.string :attach
      t.integer :score
      t.string :answer
      t.string :answer_attach
      t.string :type

      t.timestamps null: false
    end
  end
end
