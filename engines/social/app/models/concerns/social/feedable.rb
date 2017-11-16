module Social
  # 直播公共功能
  module Feedable
    extend ActiveSupport::Concern

    included do
      has_many :feeds, as: :feedable
    end

    class_methods do
      def attach_feed(*events)
        check_events(events).each do |event|
          event.is_a?(Hash) ? save_event(event) : common_event(event)
        end
      end

      def common_event(event)
        send(event, :xxxxx)
      end

      def save_event
      end

      def check_events(events)
        events.select {|event| event.is_a?(Hash) || event.in?(%w(after_create after_destroy)) }
      end

    end
  end
end
