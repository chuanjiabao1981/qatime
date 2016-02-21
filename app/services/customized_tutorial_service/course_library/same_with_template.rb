module CustomizedTutorialService
  module CourseLibrary
    class SameWithTemplate
      def initialize(customized_tutorial)
        @customized_tutorial = customized_tutorial
      end

      def judge?
        return false if @customized_tutorial.nil?
        diff = []
        course_publication = @customized_tutorial.course_publication
        return false if course_publication.nil?

        template = course_publication.course

        if template.nil?
          diff << "not exsits"
        end

        if @customized_tutorial.title != template.title
          diff << "title"
        end

        if @customized_tutorial.content != template.description
          diff << "description"
        end
        ##只有在发布lecture的情况下才进行比较
        if course_publication.publish_lecture_switch
          m_diff   =
              ::CourseLibrary::Util::MaterialDiff.new(template,@customized_tutorial).call
          diff     = diff + m_diff
        end

        @customized_tutorial.exercises.each do |exercise|
          #只对有template的exercise 判断是否相同
          if not exercise.homework_publication.nil? and not ExerciseService::CourseLibrary::SameWithTemplate.new(exercise).judge?
            diff << "exercise #{exercise.id}"
          end
        end
        if diff.blank?
          return true
        end
        return false
      end

      private
      def same_array?(a,b)
        a = a || []
        b = b || []
        a.uniq.sort  == b.uniq.sort
      end

    end
  end
end
class CustomizedTutorial::SameWithTemplate

end
