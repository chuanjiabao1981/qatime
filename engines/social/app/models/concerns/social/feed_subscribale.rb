module Social
  # 直播公共功能
  module FeedSubscribale
    extend ActiveSupport::Concern

    included do
    end

    class_methods do
      def subscribe_feed(class_key, action)
        ActiveSupport::Notifications.subscribe("#{class_key}.#{action}") do |name, _start, _finish, _id, _payload|
        end
      end
    end
  end
end
