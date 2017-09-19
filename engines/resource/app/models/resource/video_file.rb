module Resource
  class VideoFile < Resource::File
    has_one :video_info

    after_create :instance_video_info
    def instance_video_info
      capture = Qatime::VideoUtil.capture(attach.file_url)
      duration ||= Qatime::VideoUtil.duration(attach.file_url)
      build_video_info(url: attach.file_url, capture: capture, duration: duration).save!
    end
  end
end
