module LiveStudio
  # 直播公共功能
  module LiveCommon
    extend ActiveSupport::Concern

    def subject_name
      self.class.subject_names[subject] || 'unknown'
    end

    class_methods do
      def subject_names
        @subject_names ||= {
          '语文' => 'chinese',
          '数学' => 'mathematics',
          '英语' => 'english',
          '物理' => 'physics',
          '化学' => 'chemistry',
          '生物' => 'biology',
          '政治' => 'politics',
          '历史' => 'history',
          '地理' => 'geography',
          '科学' => 'science'
        }
      end
    end
  end
end
