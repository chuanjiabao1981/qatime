module Entities
  module Chat
    class Team < Grape::Entity
      expose :announcement
      expose :team_id
      expose :team_announcements, using: Entities::Chat::TeamAnnouncement
      expose :accounts, using: Entities::Chat::Account
    end
  end
end
