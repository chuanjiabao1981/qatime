module TeachingProgram
  class Course < ActiveRecord::Base
    belongs to :directory
    has one :video, as: :videoable 
    has many :homeworks 
  end
end
