# This migration comes from social (originally 20171116075023)
class CreateSocialFollows < ActiveRecord::Migration
  def change
    create_table :social_follows do |t|
      t.references :target, polymorphic: true, index: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
