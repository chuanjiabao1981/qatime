class AddCourseIdToQrCodes < ActiveRecord::Migration
  def change
    add_column :qr_codes, :coupon_id, :integer
    add_index :qr_codes, :coupon_id
  end
end
