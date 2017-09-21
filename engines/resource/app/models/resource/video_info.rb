module Resource
  class VideoInfo < ActiveRecord::Base
    belongs_to :video_file

    mount_uploader :capture, Resource::VideoInfoCaptureUploader

    def format_duration
      return if duration.nil? || duration <= 0
      tmp = duration
      second = format('%02d', tmp % 60)
      tmp /= 60
      minute = format('%02d', tmp % 60)
      tmp /= 60
      hour = format('%02d', tmp % 60)
      "#{hour}:#{minute}:#{second}"
    end
  end
end
