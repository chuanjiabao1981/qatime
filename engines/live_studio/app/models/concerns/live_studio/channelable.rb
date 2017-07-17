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
      init_board_channels unless channels.find(&:board?)
      init_camera_channels unless channels.find(&:camera?)
    end

    # 白板推流地址
    def board_push_stream
      push_streams.find {|stream| stream.use_for == 'board' }.try(:address)
    end

    # 白板拉流地址
    def board_pull_stream(protocol = 'http')
      pull_streams.find {|stream| stream.use_for == 'board' && stream.protocol == protocol }.try(:address)
    end

    # 摄像头推流地址
    def camera_push_stream
      push_streams.find {|stream| stream.use_for == 'camera' }.try(:address)
    end

    # 摄像头拉流地址
    def camera_pull_stream(protocol = 'http')
      pull_streams.find {|stream| stream.use_for == 'camera' && stream.protocol == protocol }.try(:address)
    end

    def board_channel
      channels.find_by(use_for: Channel.use_fors['board'])
    end

    private

    def init_board_channels
      channels.create(name: "#{name} - 直播室 - #{model_name} #{id} - 白板", channelable: self, use_for: :board)
    end

    def init_camera_channels
      channels.create(name: "#{name} - 直播室 - #{model_name} #{id} - 摄像头", channelable: self, use_for: :camera)
    end
  end
end
