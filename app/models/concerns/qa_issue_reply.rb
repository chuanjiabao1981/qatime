module QaIssueReply
  extend ActiveSupport::Concern
  included do
    validates :content, length: {minimum: 5},on: :create

    def reply_to
      if self.author.teacher?
        self.customized_course.student
      else
        self.customized_course.teachers.first
      end
    end

    def notify
      from    = self.author
      to      = self.reply_to
      SmsWorker.perform_async(SmsWorker::NOTIFY,
                              from: from.view_name,
                              to: to.view_name,
                              mobile: to.mobile,
                              message: self._notify_message
      )
    end

  end



end