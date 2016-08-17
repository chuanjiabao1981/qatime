module Entities
  module Chat
    class TeamAnnouncement < Grape::Entity
      expose :announcement
      expose :edit_at
    end
  end
end
