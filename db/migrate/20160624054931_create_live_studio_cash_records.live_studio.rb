# This migration comes from live_studio (originally 20160624054847)
class CreateLiveStudioCashRecords < ActiveRecord::Migration
  def change
    create_table :live_studio_cash_records do |t|
      t.references :cash_account, index: true
      t.decimal :before, precision: 10, scale: 2
      t.decimal :after, precision: 10, scale: 2
      t.decimal :different, precision: 10, scale: 2
      t.references :ref, polymorphic: true, index: true
      t.string :remark

      t.timestamps null: false
    end
  end
end
