class AddCategoryIdToSoftwares < ActiveRecord::Migration
  def change
    add_reference :softwares, :software_category, index: true
    add_column :softwares, :download_description, :string
  end
end
