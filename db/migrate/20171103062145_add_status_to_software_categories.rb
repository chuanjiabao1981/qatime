class AddStatusToSoftwareCategories < ActiveRecord::Migration
  def change
    add_column :software_categories, :status, :integer, default: 0
  end
end
