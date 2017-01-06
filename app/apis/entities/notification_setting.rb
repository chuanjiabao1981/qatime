module Entities
  class NotificationSetting < Grape::Entity
    expose :owner_id
    expose :notice
    expose :email
    expose :message
    expose :before_hours
    expose :before_minutes
  end
end
