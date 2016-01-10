module TeachingProgram
  class Solution < ActiveRecord::Base
    belongs to :homework
    has one :video, as: :videoable 
  end
end
