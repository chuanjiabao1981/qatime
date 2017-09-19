module Resource
  class VideoInfo < ActiveRecord::Base
    belongs_to :video_file

    mount_uploader :capture, Resource::VideoInfoCaptureUploader
  end
end
