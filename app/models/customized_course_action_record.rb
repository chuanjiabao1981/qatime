class CustomizedCourseActionRecord < ActionRecord

  belongs_to :customized_course

  has_many    :customized_course_action_notifications,as: :notificationable ,:dependent => :destroy do
    def build(attributes={})
      attributes[:operator_id]                   = proxy_association.owner.operator_id
      attributes[:customized_course_id]          = proxy_association.owner.customized_course_id
      super attributes
    end
  end

  after_create :__create_action_notification


  attr_accessor :send_sms_notification

  # self.send_sms_notification                    = true

  def initialize(attributes = nil, options = {})
    super(attributes,options)
    self.send_sms_notification = true
  end


  def __create_action_notification
    #如果没有customized_course就不创建这个消息
    return unless self.action_notification_receiver_ids
    self.action_notification_receiver_ids.each do |receiver_id|
      n = self.customized_course_action_notifications.build(action_name: self.name,receiver_id: receiver_id)
      n.save
      if send_sms_notification
        __create_action_sms_notification(receiver_id,n)
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


end