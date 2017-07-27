module LiveStudio
  class CustomizedGroup < Group
    has_many :scheduled_lessons, class_name: 'ScheduledLesson', foreign_key: :group_id, dependent: :destroy
    has_many :offline_lessons, class_name: 'OfflineLesson', foreign_key: :group_id, dependent: :destroy
    has_many :instant_lessons, class_name: 'OfflineLesson', foreign_key: :group_id, dependent: :destroy

    accepts_nested_attributes_for :scheduled_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    accepts_nested_attributes_for :offline_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
  end
end
