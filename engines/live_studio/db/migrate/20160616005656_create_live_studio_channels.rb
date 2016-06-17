class CreateLiveStudioChannels < ActiveRecord::Migration
  def change
    create_table :live_studio_channels do |t|
      t.string :name, limit: 255
      t.references :course, index: true
      t.string :remote_id, limit: 100
      t.integer :state, default: 0

      t.timestamps null: false
    end
  end
end
