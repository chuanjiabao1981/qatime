class CreateSoftwares < ActiveRecord::Migration
  def change
    create_table :softwares do |t|
      t.string :logo

      t.string :title
      t.string :sub_title
      t.text :desc

      t.string :role
      t.string :version
      t.integer :platform

      t.string :qr_code
      t.string :download_links

      t.timestamps null: false
    end
  end
end
