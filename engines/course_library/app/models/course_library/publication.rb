module CourseLibrary
  class Publication < ActiveRecord::Base
    belongs_to :course,class_name: CourseLibrary::Course
    belongs_to :customized_course, class_name: "CustomizedCourse"
  end
end
