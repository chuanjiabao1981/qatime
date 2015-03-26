class CreateVipClasses < ActiveRecord::Migration
  def change
    create_table :vip_classes do |t|
      t.string :subject
      t.string :category
      t.integer :questions_count, defaut: 0
      t.timestamps null: false
    end
  end
end
