module Entities
  module LiveStudio
    class ChatAccount < Grape::Entity
      expose :user_id
      expose :accid
      expose :token
      expose :name
      expose :icon
    end
  end
end
