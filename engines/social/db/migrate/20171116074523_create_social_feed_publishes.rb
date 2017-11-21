class CreateSocialFeedPublishes < ActiveRecord::Migration
  def change
    create_table :social_feed_publishes do |t|
      t.references :feed, index: true
      t.references :publisher, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
