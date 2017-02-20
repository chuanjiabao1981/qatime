module Entities
  module Chat
    class TeamAnnouncement < Grape::Entity
      expose :announcement
      expose :edit_at do |announcement|
        announcement.edit_at.try(:to_s, :db)
      end
    end
  end
end
