class AddDescriptionToPushMessages < ActiveRecord::Migration
  def change
    add_column :push_messages, :description, :string, default: ''
    add_column :push_messages, :play_vibrate, :boolean, default: true
    add_column :push_messages, :play_lights, :boolean, default: true
    add_column :push_messages, :play_sound, :boolean, default: true
  end
end
