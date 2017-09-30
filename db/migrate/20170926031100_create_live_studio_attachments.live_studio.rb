# This migration comes from live_studio (originally 20170926031026)
class CreateLiveStudioAttachments < ActiveRecord::Migration
  def change
    create_table :live_studio_attachments do |t|
      t.references :attachable, polymorphic: true
      t.string :file
      t.string :file_type
      t.integer :pos

      t.timestamps null: false
    end

    add_index :live_studio_attachments, ["attachable_id", "attachable_type"], name: 'index_live_studio_attachments_on_attachable'
  end
end
