class NotificationSenderJob < ActiveJob::Base
  queue_as :notification

  def perform(send_service_name, action_name, *object)
    send_service = send_service_name.constantize.new(*object)
    send_service.notice(action_name.to_sym)
  end
end
