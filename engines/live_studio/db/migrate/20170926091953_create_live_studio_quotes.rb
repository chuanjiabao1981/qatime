class CreateLiveStudioQuotes < ActiveRecord::Migration
  def change
    create_table :live_studio_quotes do |t|
      t.references :attachment, index: true
      t.references :quoter, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
