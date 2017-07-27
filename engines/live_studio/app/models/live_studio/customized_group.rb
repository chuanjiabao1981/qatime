module LiveStudio
  class CustomizedGroup < Group
    has_many :scheduled_lessons, class_name: 'ScheduledLesson', foreign_key: :group_id, dependent: :destroy
    has_many :offline_lessons, class_name: 'OfflineLesson', foreign_key: :group_id, dependent: :destroy
    has_many :instant_lessons, class_name: 'OfflineLesson', foreign_key: :group_id, dependent: :destroy

    accepts_nested_attributes_for :scheduled_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    accepts_nested_attributes_for :offline_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }

    # 返回所有版本的图片地址
    def publicizes_url
      %w(app_info list info).map {|v| [v, publicize_url(v)] }.to_h
    end

    # 当前价格
    def current_price
      price.to_f.round(2)
    end
  end
end
