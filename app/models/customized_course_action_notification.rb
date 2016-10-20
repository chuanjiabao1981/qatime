class CustomizedCourseActionNotification < Notification
  belongs_to :operator,class_name: User
  belongs_to :notificationable, polymorphic: true
  belongs_to :customized_course

  # 通知内容
  def notice_content
    notificationable.desc
  end
end
