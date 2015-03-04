class CreateTeachingPrograms < ActiveRecord::Migration
  def change
    create_table :teaching_programs do |t|
      t.string :name
      t.string :category
      t.string :grade
      t.string :subject
      t.jsonb  :content
      t.timestamps null: false
    end
  end
end
