# This migration comes from recommend (originally 20161027072345)
class CreateRecommendPositions < ActiveRecord::Migration
  def change
    create_table :recommend_positions do |t|
      t.string :name
      t.string :klass_name
      t.string :kee, index: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
