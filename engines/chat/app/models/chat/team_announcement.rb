module Chat
  class TeamAnnouncement < ActiveRecord::Base
    belongs_to :team
  end
end
