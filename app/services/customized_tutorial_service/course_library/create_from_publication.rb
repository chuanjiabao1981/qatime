module CustomizedTutorialService
  module CourseLibrary
    class CreateFromPublication

      def initialize(course_publication)
        @course_publication  = course_publication
      end

      def call
        #如果customized_course中已经了有一个customized_tutorial使用此publication， 则直接返回
        already_tutorials =  CustomizedTutorial.where(customized_course_id: @course_publication.customized_course_id,
                                                      course_publication_id: @course_publication.id)
        if not already_tutorials.blank?
          #虽然已经已经有了，但是也要看下是否有新的作业可以发布
          CreateExercisesFromPublications.new(@course_publication.homework_publications).call
          return already_tutorials.first
        end

        # 没有的话,创建
        customized_tutorial_template  = @course_publication.course
        a = @course_publication.build_customized_tutorial(customized_course_id: @course_publication.customized_course_id,
                                                          title: customized_tutorial_template.title,
                                                          content: customized_tutorial_template.description,
                                                          teacher_id: customized_tutorial_template.directory.syllabus.author.id,
                                                          last_operator_id: customized_tutorial_template.author_id
        )


        if @course_publication.publish_lecture_switch
          a.template_video        = customized_tutorial_template.video
          a.template_picture_ids  = customized_tutorial_template.picture_ids
          a.template_file_ids     = customized_tutorial_template.qa_file_ids
        end
        a.save!

        CreateExercisesFromPublications.new(@course_publication.homework_publications).call
        a
      end
    end
  end
end
