class AddTagtoLesson < ActiveRecord::Migration
  def change
    add_column :lessons,:tags,:jsonb,default: '[]'
    add_index :lessons,:tags, using: :gin
  end
end
