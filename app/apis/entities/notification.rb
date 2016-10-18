module Entities
  class Notification < Grape::Entity
    expose :id
    expose :read
    expose :action_name
    expose :notice_content
    expose :type do |n|
      n.notificationable.model_name.i18n_key
    end
    expose :action_name
    expose :created_at do |n|
      I18n.localize n.created_at, format: :short
    end
  end
end
