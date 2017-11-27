module Entities
  module Chat
    class Team < Grape::Entity
      expose :announcement
      expose :team_id
      expose :team_announcements, using: Entities::Chat::TeamAnnouncement
      expose :accounts, using: Entities::Chat::Account
      expose :members, using: Entities::Chat::Member
      expose :discussable_id
      expose :discussable_type
      expose :discussable_name
      expose :discussable_publicize
    end
  end
end
