module Chat
  class Team < ActiveRecord::Base

    has_many :join_records

  end
end
