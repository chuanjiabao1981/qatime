class CreateLiveStudioCourses < ActiveRecord::Migration
  def change
    create_table :live_studio_courses do |t|
      t.string :name, limit: 100, null: false
      t.references :teacher, index: true
      t.references :workstation, index: true, null: false
      t.integer :status, default: 0
      t.text :description
      t.decimal :price, precision: 6, scale: 2, default: 0.0

      t.timestamps null: false
    end
  end
end
