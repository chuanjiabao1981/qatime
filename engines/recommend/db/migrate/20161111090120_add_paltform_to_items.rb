class AddPaltformToItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :platforms, :text
    add_column :recommend_items, :city_id, :integer
    add_column :recommend_items, :link, :string
  end
end
