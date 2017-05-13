module Chat
  class TeamCreatorJob < ActiveJob::Base
    queue_as :chat

    def perform(discussable_type, discussable_id)
      discussable_type.constantize.find(discussable_id).instance_team
    end
  end
end
