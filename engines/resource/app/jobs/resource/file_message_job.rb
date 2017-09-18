module Resource
  class FileMessageJob < ActiveJob::Base
    queue_as :team_custom_message

    def perform(id, action = nil)
      Resource::Quote.find(id).send_team_message(action)
    end
  end
end
