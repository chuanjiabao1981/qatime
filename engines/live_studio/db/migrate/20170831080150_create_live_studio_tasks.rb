class CreateLiveStudioTasks < ActiveRecord::Migration
  def change
    create_table :live_studio_tasks do |t|
      t.string :title
      t.text :body
      t.references :taskable, polymorphic: true, index: true
      t.references :parent, index: true
      t.references :user, index: true
      t.string :type

      t.timestamps null: false
    end
  end
end
