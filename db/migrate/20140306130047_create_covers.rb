class CreateCovers < ActiveRecord::Migration
  def change
    create_table :covers do |t|
      t.string :name
      t.timestamps
    end
  end
end
