module Social
  # 直播公共功能
  module Feedable
    extend ActiveSupport::Concern

    included do
      has_many :feeds, as: :feedable
    end

    class_methods do
      def publish_feeds(action, callback, options = {})
        send(action, callback, options)
      end
    end
  end
end
