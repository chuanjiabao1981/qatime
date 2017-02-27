class AddBillingPercentToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :system_percentage, :integer, default: 0 # 系统分成比例
    add_column :live_studio_courses, :publish_percentage, :integer, default: 0 # 发行分成比例
    add_column :live_studio_courses, :sell_percentage, :integer, default: 0 # 销售分成比例
    add_column :live_studio_courses, :base_price, :decimal, precision: 4, scale: 2, default: 0.1 # 系统服务费价格默认1毛钱1分钟
  end
end
