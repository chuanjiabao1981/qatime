module QaCustomizedCourseActionNotification
  extend ActiveSupport::Concern
  included do
    has_many   :customized_course_action_notifications,as: :notificationable,:dependent => :destroy do
      def build(attributes={})
        attributes[:operator_id]                   = proxy_association.owner.operator_id
        attributes[:customized_course_id]          = proxy_association.owner.customized_course_id
        super attributes
      end
    end

    # 给一个默认方法 ，这个消息就是给专属课堂居用，所以把这种情况作为默认值
    def action_notification_receiver_ids
      a = []
      return a unless defined? self.customized_course and self.customized_course
      a = a +  self.customized_course.teacher_ids
      a = a << self.customized_course.student_id
      a = a - [self.operator_id]
      a
    end

    after_create :__create_action_notification
  end



  private
  def __create_action_notification
    #如果没有customized_course就不创建这个消息
    return unless self.action_notification_receiver_ids
    self.action_notification_receiver_ids.each do |receiver_id|
      n = self.customized_course_action_notifications.build(action_name: :create,receiver_id: receiver_id)
      n.save
      __create_action_sms_notification(receiver_id,n)
    end
  end

  def __create_action_sms_notification(receiver_id,notification)
    to        = User.find(receiver_id)
    if notification.notificationable_type == 'Comment'
      message   = I18n.t "action.#{notification.notificationable.model_name.singular_route_key}.#{notification.action_name}.desc",
                         user: notification.operator.view_name,
                         what: notification.notificationable.commentable.model_name.human
    else
      message   = I18n.t "action.#{notification.notificationable.model_name.singular_route_key}.#{notification.action_name}.desc",
                user: notification.operator.view_name
    end
    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            to: to.view_name,
                            mobile: to.mobile,
                            message: message
    )
  end
end