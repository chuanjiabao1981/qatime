class CustomizedCourseAssignment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :customized_course
end
