class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :type
      t.string :key
      t.integer :value
      t.string :ext

      t.timestamps null: false
    end
  end
end
