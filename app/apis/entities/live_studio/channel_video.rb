module Entities
  module LiveStudio
    class ChannelVideo < Grape::Entity
      expose :id do |video|
        video.try(:vid)
      end
      expose :duration
      expose :format do |_|
        'mp4'
      end
      expose :url do |video|
        video.sd_mp4_url
      end
      expose :hd_url do |video|
        video.hd_mp4_url
      end
      expose :shd_url do |video|
        video.shd_mp4_url
      end
    end
  end
end
