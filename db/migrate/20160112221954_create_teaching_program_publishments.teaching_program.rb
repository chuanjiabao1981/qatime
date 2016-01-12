# This migration comes from teaching_program (originally 20160112220441)
class CreateTeachingProgramPublishments < ActiveRecord::Migration
  def change
    create_table :teaching_program_publishments do |t|
      t.integer :course_id
      t.references :course,index: true
      t.references :courseable,polymorphic: true
      t.timestamps null: false
    end
  end
end
