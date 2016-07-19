module LiveStudio
  class LiveSession < ActiveRecord::Base
    belongs_to :lesson
  end
end
