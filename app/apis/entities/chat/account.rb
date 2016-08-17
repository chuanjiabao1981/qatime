module Entities
  module Chat
    class Account < Grape::Entity
      expose :accid
      expose :name
      expose :icon
    end
  end
end
