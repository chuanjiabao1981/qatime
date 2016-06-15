class CreateLiveStudioLiveStreams < ActiveRecord::Migration
  def change
    create_table :live_studio_live_streams do |t|
      t.string :address

      t.timestamps null: false
    end
  end
end
