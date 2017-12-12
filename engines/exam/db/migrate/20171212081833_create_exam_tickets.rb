class CreateExamTickets < ActiveRecord::Migration
  def change
    create_table :exam_tickets do |t|
      t.references :student, index: true
      t.references :product, polymorphic: true, index: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
