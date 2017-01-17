class ChannelWorkder
  include Sidekiq::Worker

  # 更新辅导班录制视频列表
  def perform(course_id)
    course = LiveStudio::Course.find(course_id)
    course.channels.each do |channel|
      channel.set_always_recorded && channel.update_video_list
    end
  end
end
