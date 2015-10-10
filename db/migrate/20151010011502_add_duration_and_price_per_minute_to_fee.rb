class AddDurationAndPricePerMinuteToFee < ActiveRecord::Migration
  def change
    add_column :fees,:price_per_minute,:float
    add_column :fees,:video_duration,:float
  end
end
