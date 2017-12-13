# This migration comes from exam (originally 20171205031040)
class CreateExamPapers < ActiveRecord::Migration
  def change
    create_table :exam_papers do |t|
      t.belongs_to :workstation, index: true, foreign_key: true
      t.string :name
      t.string :grade_category
      t.string :grade
      t.string :subject
      t.decimal :price, precision: 8, scale: 2
      t.integer :status
      t.integer :topics_count, default: 0
      t.integer :duration
      t.integer :score
      t.string :type
      t.timestamp :published_at

      t.timestamps null: false
    end
  end
end

