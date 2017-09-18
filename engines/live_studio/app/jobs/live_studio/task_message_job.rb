module LiveStudio
  class TaskMessageJob < ActiveJob::Base
    queue_as :task_message

    def perform(id, action = nil)
      LiveStudio::Task.find(id).send_task_message(action)
    end
  end
end
