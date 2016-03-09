module CustomizedTutorialService
  module CourseLibrary
    class CreateFromPublication

      def initialize(course_publication)
        @course_publication  = course_publication
      end

      def call

        customized_tutorial_template  = @course_publication.course

        #如果customized_course中已经了有一个customized_tutorial使用此publication
        already_tutorials =  CustomizedTutorial.where(customized_course_id: @course_publication.customized_course_id,
                                                      course_publication_id: @course_publication.id)
        a                 = nil

        if already_tutorials.length > 1
          #一个课程发布给多个专属课程出错
          raise "find too many publication for course #{@course_publication.course.id} in customized_course #{@course_publication.customized_course_id}"
        elsif already_tutorials.length == 1
          #专属课程已经有了
          a = already_tutorials.first
        else
          # 没有专属课程,build
          a = @course_publication.build_customized_tutorial(customized_course_id: @course_publication.customized_course_id,
                                                          title: customized_tutorial_template.title,
                                                          content: customized_tutorial_template.description,
                                                          teacher_id: customized_tutorial_template.directory.syllabus.author.id,
                                                          last_operator_id: customized_tutorial_template.author_id
          )
        end

        if not a.has_lecture? #如果已经有了则表明已经发布过了所以什么都不需要做
          if @course_publication.publish_lecture_switch #没有lecture，且要发布则创建它
            _create_lecture(a,customized_tutorial_template)
          end
        end
        a.save!

        #是否有homework需要发布
        CreateExercisesFromPublications.new(@course_publication.homework_publications).call
        a
      end
      private
      def _create_lecture(customized_tutorial,customized_tutorial_template)
        customized_tutorial.template_video        = customized_tutorial_template.video
        customized_tutorial.template_picture_ids  = customized_tutorial_template.picture_ids
        customized_tutorial.template_file_ids     = customized_tutorial_template.qa_file_ids
      end
    end


  end
end
