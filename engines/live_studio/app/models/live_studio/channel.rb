module LiveStudio
  class Channel < ActiveRecord::Base
    belongs_to :course

    has_many :streams

    private
    after_create :create_remote_channel

    def create_remote_channel
      streams.create()
    end
  end
end
