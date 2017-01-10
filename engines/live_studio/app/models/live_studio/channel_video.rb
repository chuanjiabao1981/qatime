module LiveStudio
  class ChannelVideo < ActiveRecord::Base
    belongs_to :channel
  end
end
