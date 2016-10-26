class AddUseForToLiveStudioChannels < ActiveRecord::Migration
  def change
    add_column :live_studio_channels, :use_for, :integer, default: 0
  end
end
