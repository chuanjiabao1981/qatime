class CreateLiveStudioGroups < ActiveRecord::Migration
  def change
    create_table :live_studio_groups do |t|
      t.string :name, limit: 100, null: false
      t.string :subject # 科目
      t.string :grade # 年级
      t.string :publicize # 海报图片
      t.text :description # 详情
      t.string :objective # 课程目标
      t.string :suit_crowd # 适合人群
      t.string :announcement # 公告
      t.integer :status, default: 0 # 状态
      t.string :type, limit: 150 # 类型
      t.references :teacher, index: true # 老师
      t.references :workstation, index: true # 工作站
      t.references :province, index: true # 所属省份
      t.references :city, index: true # 所属城市
      t.references :author, index: true # 创建者
      t.decimal :price, precision: 8, scale: 2, default: 0.0 # 价格
      t.integer :taste_count, limit: 4, default: 0 # 可试听数量
      t.decimal :left_price, precision: 8, scale: 2, default: 0.0 # 剩余价格
      t.decimal :base_price, precision: 6, scale: 2, default: 0.0 # 服务费价格
      t.integer :sell_type, limit: 2, default: 1 # 销售类型
      t.integer :events_count, limit: 4, default: 0 # 课程数量
      t.integer :scheduled_lessons_count, limit: 4, default: 0 # 直播课程数量
      t.integer :offline_lessons_count, limit: 4, default: 0 # 线下课程数量
      t.integer :instant_lessons_count, limit: 4, default: 0 # 即时课程数量
      t.integer :teacher_percentage, limit: 4, default: 0 # 教师分成
      t.integer :publish_percentage, default: 0 # 发行分成
      t.integer :platform_percentage, default: 0 # 平台分成
      t.integer :sell_and_platform_percentage, default: 0 # 销售和平台分成
      t.integer :buy_tickets_count, default: 0 # 购买人数
      t.integer :view_tickets_count, default: 0 # 显示购买人数
      t.integer :adjust_tickets_count, default: 0 # 调整购买人数
      t.integer :tickets_count, default: 0 # 听课人数, 包括试听
      t.integer :closed_events_count, default: 0 # 已上课数量
      t.integer :started_events_count, default: 0 # 已开课数量
      t.string :token, index: true # 图片上传标识
      t.datetime :start_at, index: true # 开课时间
      t.datetime :end_at # 结课时间
      t.datetime :published_at, index: true # 招生时间
      t.datetime :deleted_at
      t.timestamps null: false
    end

  end
end
