module Resource
  class VideoFile < File
    has_one :video_info
  end
end
