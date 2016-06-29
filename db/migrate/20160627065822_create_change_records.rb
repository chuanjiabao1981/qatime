class CreateChangeRecords < ActiveRecord::Migration
  def change
    create_table :change_records do |t|
      t.references :cash_account, index: true, foreign_key: true
      t.decimal :before, precision: 8, scale: 2
      t.decimal :after, precision: 8, scale: 2
      t.decimal :different, precision: 8, scale: 2
      t.references :ref, polymorphic: true, index: true
      t.string :summary

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
