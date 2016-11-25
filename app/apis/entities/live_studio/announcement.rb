module Entities
  module LiveStudio
    class Announcement < Grape::Entity
      expose :content
      expose :lastest
      expose :announcement do |a|
        a.content
      end
      expose :edit_at do |a|
        a.create_time
      end
      expose :created_at do |a|
        a.create_time
      end
    end
  end
end
