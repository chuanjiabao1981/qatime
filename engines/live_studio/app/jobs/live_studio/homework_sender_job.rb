module LiveStudio
  class HomeworkSenderJob < ActiveJob::Base
    queue_as :default

    def perform(group_id, student_id)
      LiveStudio::CustomizedGroup.find(group_id).send_homeworks_to(student_id)
    end
  end
end
