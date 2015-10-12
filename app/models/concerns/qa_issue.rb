module QaIssueReply
  extend ActiveSupport::Concern
  included do

    def ask_to
      self.customized_course.teachers.first
    end

    def notify
      from    = self.author
      to      = self.ask_to
      SmsWorker.perform_async(SmsWorker::NOTIFY,
                              from: from.view_name,
                              to: to.view_name,
                              mobile: to.mobile,
                              message: self._notify_message
      )
    end


    def _notify_message
      "提了一个#{self.model_name.human},请关注"
    end

  end



end