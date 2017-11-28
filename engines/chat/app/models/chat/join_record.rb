module Chat
  class JoinRecord < ActiveRecord::Base
    delegate :name, :accid, :icon, to: :account

    belongs_to :account
    belongs_to :team
  end
end
