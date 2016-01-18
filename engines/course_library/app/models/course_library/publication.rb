module CourseLibrary
  class Publication < ActiveRecord::Base
    belongs_to :course,class_name: CourseLibrary::Course
    belongs_to :customized_tutorial, class_name: "CustomizedTutorial"


    def build_a_customized_tutorial(customized_course_id)
      self.build_customized_tutorial(customized_course_id: customized_course_id,
                                     title: self.course.title,


      )
    end
  end
end
