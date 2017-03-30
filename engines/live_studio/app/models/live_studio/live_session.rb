module LiveStudio
  class LiveSession < ActiveRecord::Base
    belongs_to :sessionable, polymorphic: true
  end
end
