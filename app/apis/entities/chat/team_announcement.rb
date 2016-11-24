module Entities
  module Chat
    class TeamAnnouncement < Grape::Entity
      expose :announcement
      expose :edit_at do |announcement|
        edit_at.to_s(:db)
      end
    end
  end
end
