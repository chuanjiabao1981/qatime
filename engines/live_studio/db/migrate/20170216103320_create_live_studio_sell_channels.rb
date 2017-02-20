class CreateLiveStudioSellChannels < ActiveRecord::Migration
  def change
    create_table :live_studio_sell_channels do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :target, polymorphic: true, index: true
      t.integer :percentage

      t.timestamps null: false
    end
  end
end
