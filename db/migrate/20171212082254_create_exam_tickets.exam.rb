# This migration comes from exam (originally 20171212081833)
class CreateExamTickets < ActiveRecord::Migration
  def change
    create_table :exam_tickets do |t|
      t.references :student, index: true
      t.references :product, polymorphic: true, index: true
      t.decimal :price, precision: 8, scale: 2
      t.references :payment_order
      t.integer :status

      t.timestamps null: false
    end
  end
end
