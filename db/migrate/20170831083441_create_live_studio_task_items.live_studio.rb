# This migration comes from live_studio (originally 20170831082740)
class CreateLiveStudioTaskItems < ActiveRecord::Migration
  def change
    create_table :live_studio_task_items do |t|
      t.string :title
      t.text :body
      t.references :task, index: true
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
