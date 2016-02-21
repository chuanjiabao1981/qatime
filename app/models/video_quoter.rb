class VideoQuoter < ActiveRecord::Base
  belongs_to :video
  belongs_to :file_quoter, polymorphic: true
end
