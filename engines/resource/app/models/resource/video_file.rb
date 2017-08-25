module Resource
  class VideoFile < Resource::File
    has_one :video_info
  end
end
