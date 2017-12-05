class CreateExamPapers < ActiveRecord::Migration
  def change
    create_table :exam_papers do |t|
      t.belongs_to :workstation, index: true, foreign_key: true
      t.string :name
      t.string :grade
      t.string :subject
      t.decimal :price, precision: 8, scale: 2
      t.integer :status
      t.integer :topics_count
      t.integer :duration
      t.string :type

      t.timestamps null: false
    end
  end
end
