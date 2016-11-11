class AddPaltformToItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :platforms, :text
  end
end
