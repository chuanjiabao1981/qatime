# This migration comes from live_studio (originally 20170831080150)
class CreateLiveStudioTasks < ActiveRecord::Migration
  def change
    create_table :live_studio_tasks do |t|
      t.string :title
      t.text :body
      t.references :taskable, polymorphic: true, index: true
      t.references :parent, index: true
      t.references :user, index: true
      t.references :teacher, index: true
      t.integer :status
      t.integer :tasks_count, default: 0
      t.string :type

      t.timestamps null: false
    end
  end
end
