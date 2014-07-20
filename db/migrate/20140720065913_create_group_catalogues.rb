class CreateGroupCatalogues < ActiveRecord::Migration
  def change
    create_table :group_catalogues do |t|
      t.references :group_type
      t.string :name
      t.integer :index
      t.timestamps
    end
  end
end
