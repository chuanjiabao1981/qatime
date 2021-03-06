module CourseLibrary
  class Solution < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :homework
    include VideoAccessor
    include QaFileAccessor
    include PictureAccessor
    include CourseLibrary::Concerns::Solution::Utils
  end
end
