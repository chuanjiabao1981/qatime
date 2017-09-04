# This migration comes from resource (originally 20170824024640)
class CreateResourceFiles < ActiveRecord::Migration
  def change
    create_table :resource_files do |t|
      t.string :name
      t.references :directory
      t.references :user, index: true, foreign_key: true
      t.integer :quotes_count
      t.references :attach, polymorphic: true, index: true
      t.decimal :file_size, precision: 16, scale: 2, default: 0.0 # 文件大小
      t.string :ext_name
      t.string :type

      t.timestamps null: false
    end
  end
end
