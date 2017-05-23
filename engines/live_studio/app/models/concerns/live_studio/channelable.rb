module LiveStudio
  module Channelable
    extend ActiveSupport::Concern

    included do
      has_many :channels, as: :channelable
      has_many :push_streams, through: :channels
      has_many :pull_streams, through: :channels
      after_create :async_init_channels
    end

    def async_init_channels
      ChannelCreateJob.perform_later(id, model_name.to_s)
    end

    def init_channels
      init_board_channels unless channels.find_by(&:board?)
      init_camera_channels unless channels.find_by(&:camera?)
    end

    private

    def init_board_channels
      channels.create(name: "#{name} - 直播室 - #{id} - 白板", channelable: self, use_for: :board)
    end

    def init_camera_channels
      channels.create(name: "#{name} - 直播室 - #{id} - 摄像头", channelable: self, use_for: :camera)
    end
  end
end
