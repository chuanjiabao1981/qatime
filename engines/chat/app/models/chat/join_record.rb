module Chat
  class JoinRecord < ActiveRecord::Base

    belongs_to :account
    belongs_to :team

  end
end
