module LiveStudio
  class RealtimeController < ApplicationController
    skip_before_action :authorize
    skip_before_action :set_city
    before_action :set_course

    # 公告
    def announcements
      @announcements = @course.announcements.order(id: :desc)
      @announcements = Announcement.order(id: :desc)
      render json: @announcements.as_json(only: [:id, :content, :lastest], methods: [:create_time])
    end

    # 群成员列表
    def members
    end

    # 直播状态
    def status
    end

    private

    def set_course
      @course = LiveStudio::Course.find(params[:course_id])
    end
  end
end
