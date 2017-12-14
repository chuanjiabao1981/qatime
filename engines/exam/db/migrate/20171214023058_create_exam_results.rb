class CreateExamResults < ActiveRecord::Migration
  def change
    create_table :exam_results do |t|
      t.references :paper, index: true
      t.references :ticket, index: true
      t.references :student
      t.decimal :score, precision: 5, scale: 2
      t.integer :status

      t.timestamps null: false
    end
  end
end
