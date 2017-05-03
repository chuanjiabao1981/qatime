class AddVideoServicePriceToWorkstations < ActiveRecord::Migration
  def change
    add_column :workstations, :video_service_price, :decimal, precision: 4, scale: 2, default: 0 # 视频课服务费
    Workstation.update_all(video_service_price: 5)
  end
end
