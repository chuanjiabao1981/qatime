module Entities
  module LiveStudio
    class Announcement < Grape::Entity
      expose :content
      expose :lastest
      expose :announcement do |a|
        a.content
      end
      expose :edit_at do |a|
        a.created_at.try(:to_s, :db)
      end
      expose :created_at do |a|
        a.created_at.try(:to_s, :db)
      end
    end
  end
end
