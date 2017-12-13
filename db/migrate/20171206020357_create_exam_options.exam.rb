# This migration comes from exam (originally 20171206020022)
class CreateExamOptions < ActiveRecord::Migration
  def change
    create_table :exam_options do |t|
      t.belongs_to :topic, index: true
      t.string :name
      t.string :title
      t.boolean :correct

      t.timestamps null: false
    end
  end
end
