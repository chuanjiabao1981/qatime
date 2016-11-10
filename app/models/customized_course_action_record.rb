class CustomizedCourseActionRecord < ActionRecord
  include Qawechat::WechatHelper
  belongs_to :customized_course

  has_many    :customized_course_action_notifications,as: :notificationable ,:dependent => :destroy do
    def build(attributes={})
      attributes[:operator_id]                   = proxy_association.owner.operator_id
      attributes[:customized_course_id]          = proxy_association.owner.customized_course_id
      super attributes
    end
  end

  after_create :__create_action_notification


  attr_accessor :send_sms_notification,:send_wechat_notification


  def initialize(attributes = {})
    super(attributes)
    self.send_sms_notification = true
    self.send_wechat_notification = true
  end

  def desc
    I18n.t "action.#{self.actionable.model_name.singular_route_key}.#{self.name}.desc",
                          user: self.operator.view_name
  end

  # 通知内容
  def notice_content
    desc
  end

  def __create_action_notification
    #如果没有customized_course就不创建这个消息
    return unless self.action_notification_receiver_ids
    self.action_notification_receiver_ids.each do |receiver_id|
      n = self.customized_course_action_notifications.build(action_name: self.name,receiver_id: receiver_id)
      n.save
      if send_sms_notification
        __create_action_sms_notification(receiver_id,self.desc)
      end
      if send_wechat_notification
        __create_action_wechat_notification(n.id,receiver_id,self.desc)
      end
    end
  end


  # 给一个默认方法 ，这个消息就是给专属课堂居用，所以把这种情况作为默认值
  def action_notification_receiver_ids
    a = []
    return a unless defined? self.customized_course and self.customized_course
    a = self.customized_course.all_participants
    a = a - [self.operator_id]
    a
  end


  def __create_action_sms_notification(receiver_id,message)
    to        = User.find(receiver_id)
    # if notification.notificationable_type == 'Comment'
    #   message   = I18n.t "action.#{notification.notificationable.model_name.singular_route_key}.#{notification.action_name}.desc",
    #                      user: notification.operator.view_name,
    #                      what: notification.notificationable.commentable.model_name.human
    # else
    #   message   = I18n.t "action.#{notification.notificationable.model_name.singular_route_key}.#{notification.action_name}.desc",
    #                      user: notification.operator.view_name
    # end
    SmsWorker.perform_async(SmsWorker::NOTIFY,
                            to: to.view_name,
                            mobile: to.mobile,
                            message: message
    )
  end

  def __create_action_wechat_notification(nid,receiver_id,mes)
    wechat_users = Qawechat::WechatUser.where(user_id: receiver_id)
    wechat_users.each do |wechat_user|
      message = mes + "，" + get_notification_href(nid, wechat_user.openid) +  "，"
      to        = User.find(receiver_id)
      WechatWorker.perform_async(WechatWorker::NOTIFY,
                                 to: to.view_name,
                                 openid: wechat_user.openid,
                                 message: message
      )
    end
  end

end
