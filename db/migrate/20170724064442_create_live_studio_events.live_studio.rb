# This migration comes from live_studio (originally 20170724061944)
class CreateLiveStudioEvents < ActiveRecord::Migration
  def change
    create_table :live_studio_events do |t|
      t.string :name, limit: 100 # 活动名称
      t.string :type # 活动类型
      t.references :group, index: true # 所属群组
      t.references :teacher, index: true # 老师
      t.string :description # 描述
      t.integer :status, limit: 2, default: 0 # 状态
      t.date :class_date # 活动日期
      t.datetime :start_at # 活动开始时间
      t.string :start_at_hour # 开始时间小时
      t.string :start_at_min # 开始时间分钟
      t.datetime :end_at # 活动结束时间
      t.integer :duration # 活动时长
      t.string :class_address # 活动地址
      t.integer :live_count, default: 0
      t.datetime :live_start_at # 活动实际开始时间
      t.datetime :live_end_at # 活动实际结束时间
      t.integer :real_time, default: 0 # 实际时长
      t.integer :pos, limit: 4, default: 0 # 排序
      t.datetime :heartbeat_time # 最后心跳时间
      t.integer  :replay_status, default: 0 # 回放状态

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
