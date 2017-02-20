class AddColumnToChannels < ActiveRecord::Migration
  def change
    add_column :live_studio_channels, :set_always_recorded, :boolean, default: false
  end
end
