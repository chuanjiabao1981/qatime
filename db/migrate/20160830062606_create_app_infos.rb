class CreateAppInfos < ActiveRecord::Migration
  def change
    create_table :app_infos do |t|
      t.string :name
      t.integer :category
      t.string :version
      t.integer :level, index: true
      t.text :description
      t.string :download_url
      t.string :qr_code
      t.integer :status, default: 0
      t.boolean :enforce
      t.integer :enforce_level
      t.datetime :running_at
      t.timestamps null: false
    end
  end
end
