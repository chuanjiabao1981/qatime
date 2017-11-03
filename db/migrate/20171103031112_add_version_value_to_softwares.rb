class AddVersionValueToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :version_value, :integer, default: 0
    Software.all.map(&:cal_version_value).map(&:save)
  end
end
