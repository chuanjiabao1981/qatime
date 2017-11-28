module Entities
  module Chat
    class Member < Grape::Entity
      expose :accid
      expose :name
      expose :icon
      expose :role
    end
  end
end
