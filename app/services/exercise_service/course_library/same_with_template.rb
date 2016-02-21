module ExerciseService
  module CourseLibrary
    class SameWithTemplate
      def initialize(exercise)
        @exercise = exercise
      end

      def judge?
        return false if @exercise.nil?
        diff = []
        return false if @exercise.homework_publication.nil?
        template = @exercise.homework_publication.homework
        if template.nil?
          diff << "not exsits"
          return false
        end
        if template.title != @exercise.title
          diff << "title"
        end
        if template.description != @exercise.content
          diff << "description"
        end
        m_diff   =
            ::CourseLibrary::Util::MaterialDiff.new(template,@exercise).call

        diff = diff + m_diff

        @exercise.solutions.each do |solution|
          solution.corrections.each do |correction|
            if not correction.template.nil?
              if not ExerciseCorrectionService::CourseLibrary::SameWithTemplate.new(correction).judge?
                diff << "correction#{correction.id}"
              end
            end
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

