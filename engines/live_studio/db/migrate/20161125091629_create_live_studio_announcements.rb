class CreateLiveStudioAnnouncements < ActiveRecord::Migration
  def change
    create_table :live_studio_announcements do |t|
      t.references :course, index: true
      t.references :creator, polymorphic: true
      t.string :content
      t.boolean :lastest

      t.timestamps null: false
    end
  end
end
