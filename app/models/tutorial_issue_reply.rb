class TutorialIssueReply < Reply



  self.per_page = 5

  belongs_to :tutorial_issue,foreign_key: "topic_id"
  belongs_to :customized_tutorial
  belongs_to :customized_course


  validates :content, length: {minimum: 5}


  def reply_to
    if self.author.teacher?
      self.customized_course.student
    else
      self.customized_tutorial.teacher
    end
  end


  def notify
    from    = self.author
    to      = self.reply_to
    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            from: from.view_name,
                            to: to.view_name,
                            mobile: to.mobile,
                            message: "回复了你在#{CustomizedTutorial.model_name.human}发起的#{TutorialIssue.model_name.human}，请关注"
    )

  end
end