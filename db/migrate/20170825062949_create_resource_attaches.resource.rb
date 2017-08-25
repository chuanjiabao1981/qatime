# This migration comes from resource (originally 20170825031631)
class CreateResourceAttaches < ActiveRecord::Migration
  def change
    create_table :resource_attaches do |t|
      t.string :file
      t.string :content_type
      t.string :ext_name
      t.integer :file_size

      t.timestamps null: false
    end
  end
end
