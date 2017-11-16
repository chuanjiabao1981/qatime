# This migration comes from social (originally 20171116074249)
class CreateSocialFeeds < ActiveRecord::Migration
  def change
    create_table :social_feeds do |t|
      t.references :feedable, polymorphic: true, index: true
      t.string :event
      t.references :producer, polymorphic: true, index: true
      t.references :target, polymorphic: true, index: true
      t.references :linkable, polymorphic: true, index: true
      t.integer :level, default: 0
      t.references :workstation, foreign_key: true

      t.timestamps null: false
    end
  end
end
