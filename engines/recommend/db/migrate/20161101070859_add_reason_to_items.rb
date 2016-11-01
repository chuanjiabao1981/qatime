class AddReasonToItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :reason, :integer
  end
end
