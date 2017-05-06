class NotificationPublisherJob < ActiveJob::Base
  queue_as :notification

  def perform(notice_type, notificationable, action_name, receivers)
    receivers = [receivers] unless receivers.is_a?(Array)
    receivers.each do |receiver|
      notice_type.constantize.create(receiver: receiver, notificationable: notificationable, action_name: action_name)
    end
  end
end
