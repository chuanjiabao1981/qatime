class CreateRecommendItems < ActiveRecord::Migration
  def change
    create_table :recommend_items do |t|
      t.string :title
      t.references :position, index: true
      t.references :target, polymorphic: true, index: true
      t.references :owner, polymorphic: true, index: true
      t.string :logo
      t.integer :index

      t.timestamps null: false
    end
  end
end
