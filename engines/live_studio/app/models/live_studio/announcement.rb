module LiveStudio
  class Announcement < ActiveRecord::Base
    belongs_to :course
    belongs_to :creator, polymorphic: true

    after_create :publish_to_team
    def publish_to_team
      team = course.try(:chat_team)
      return true unless team.present?
      Chat::IM.team_update(tid: team.team_id, owner: team.owner, announcement: team.content)
      # 发送通知消息
      LiveService::CourseNotificationSender.new(course).notice(LiveStudioCourseNotification::ACTION_NOTICE_CREATE)
    end

    def create_time
      created_at.to_s(:local).gsub(/\+0800/, '')
    end
  end
end
