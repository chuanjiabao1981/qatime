# This migration comes from resource (originally 20170824023728)
class CreateResourceQuotes < ActiveRecord::Migration
  def change
    create_table :resource_quotes do |t|
      t.references :file, index: true
      t.references :quoter, polymorphic: true

      t.timestamps null: false
    end
  end
end
