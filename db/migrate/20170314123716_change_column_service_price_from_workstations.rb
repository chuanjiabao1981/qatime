class ChangeColumnServicePriceFromWorkstations < ActiveRecord::Migration
  def change
    change_column :workstations, :service_price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
