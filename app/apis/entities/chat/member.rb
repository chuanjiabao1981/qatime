module Entities
  module Chat
    class Account < Grape::Entity
      expose :accid
      expose :name
      expose :icon
      expose :role
    end
  end
end
