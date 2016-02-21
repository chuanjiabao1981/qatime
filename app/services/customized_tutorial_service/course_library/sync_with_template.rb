module CustomizedTutorialService
  module CourseLibrary
    class SyncWithTemplate
      def initialize(customized_tutorial)
        @customized_tutorial            = customized_tutorial
        @customized_tutorial_template   = nil
        @course_publication             = nil
        if not @customized_tutorial.nil?
          @course_publication           = customized_tutorial.course_publication
          if not @course_publication.nil?
            @customized_tutorial_template = @course_publication.course
          end
        end
      end

      def call
        return if @customized_tutorial_template.nil? or @course_publication.nil?

        if not @customized_tutorial.is_charged?
          @customized_tutorial.title                 = @customized_tutorial_template.title
          @customized_tutorial.content               = @customized_tutorial_template.description
          if @course_publication.publish_lecture_switch
            @customized_tutorial.template_video        = @customized_tutorial_template.video
            @customized_tutorial.template_picture_ids  = @customized_tutorial_template.picture_ids
            @customized_tutorial.template_file_ids     = @customized_tutorial_template.qa_file_ids
          else
            @customized_tutorial.template_video        = nil
            @customized_tutorial.template_picture_ids  = []
            @customized_tutorial.template_file_ids     = []

          end
          @customized_tutorial.save
        end

        CustomizedTutorialService::CourseLibrary::SyncExercisesWithTemplate.new(@customized_tutorial).call

      end
    end
  end
end
