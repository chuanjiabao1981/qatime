# This migration comes from recommend (originally 20161101070859)
class AddReasonToItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :reason, :integer
  end
end
