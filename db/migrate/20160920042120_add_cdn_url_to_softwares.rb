class AddCdnUrlToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :cdn_url, :string
  end
end
