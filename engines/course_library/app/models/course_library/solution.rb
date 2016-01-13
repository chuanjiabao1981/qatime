module CourseLibrary
  class Solution < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :homework
    has_one :video_quoter, as: :file_quoter, class_name: "VideoQuoter"
    has_one :video, through: :video_quoter
  end
end
