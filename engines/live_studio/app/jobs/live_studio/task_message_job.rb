module LiveStudio
  class TaskMessageJob < ActiveJob::Base
    queue_as :team_custom_message

    def perform(id, action = nil)
      LiveStudio::Task.find(id).send_team_message(action)
    end
  end
end
