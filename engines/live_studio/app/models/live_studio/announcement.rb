module LiveStudio
  class Announcement < ActiveRecord::Base
    belongs_to :course
    belongs_to :creator, polymorphic: true
    belongs_to :announcementable, polymorphic: true

    after_create :publish_to_team
    def publish_to_team
      team = announcementable.try(:chat_team)
      return true unless team.present?
      Chat::IM.team_update(tid: team.team_id, owner: team.owner, announcement: content)
      # 发送通知消息
      LiveService::CourseNotificationSender.new(announcementable).notice(LiveStudioCourseNotification::ACTION_NOTICE_CREATE)
    end

    def create_time
      created_at.to_s(:local).gsub(/\+0800/, '')
    end
  end
end
