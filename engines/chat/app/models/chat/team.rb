module Chat
  class Team < ActiveRecord::Base

    belongs_to :live_studio_course, class_name: '::LiveStudio::Course'
    has_many :join_records

  end
end
