class CreateRechargeCodes < ActiveRecord::Migration
  def change
    create_table :recharge_codes do |t|
      t.integer   :money,:default=>500
      t.string    :code
      t.integer   :admin_id
      t.string    :desc
      t.boolean   :is_used,:default=>false
      t.timestamps
    end
  end
end
