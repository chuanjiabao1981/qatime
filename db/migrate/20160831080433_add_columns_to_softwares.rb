class AddColumnsToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :description, :text
    add_column :softwares, :status, :integer, default: 0
    add_column :softwares, :enforce, :boolean
    add_column :softwares, :running_at, :datetime
    add_column :softwares, :category, :integer
    rename_column :softwares, :running_at, :published_at
  end
end
