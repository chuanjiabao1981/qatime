module Media
  class Voice < ActiveRecord::Base
    belongs_to :voicable, polymorphic: true
    has_many :voice_quoters, foreign_key: :media_voice_id
  end
end
