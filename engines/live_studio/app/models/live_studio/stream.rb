module LiveStudio
  class Stream < ActiveRecord::Base
    belongs_to :channel
  end
end
