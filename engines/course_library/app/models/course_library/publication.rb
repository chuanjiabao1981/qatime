module CourseLibrary
  class Publication < ActiveRecord::Base
    belongs_to :course,class_name: CourseLibrary::Course
    belongs_to :customized_tutorial, class_name: "CustomizedTutorial"


    def build_a_customized_tutorial(customized_course_id)
      a = self.build_customized_tutorial(customized_course_id: customized_course_id,
                                     title: self.course.title,
                                     description: self.course.description,
                                     teacher_id: self.course.syllabus.author_id
      )

    end
  end
end
