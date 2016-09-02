class CreateQrCodes < ActiveRecord::Migration
  def change
    create_table :qr_codes do |t|
      t.string :code
      t.references :qr_codeable, polymorphic: true
      t.timestamps null: false
    end
    remove_column :payment_orders, :qrcode_url
    remove_column :softwares, :qr_code
  end
end
