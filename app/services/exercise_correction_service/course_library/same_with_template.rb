module ExerciseCorrectionService
  module CourseLibrary
    class SameWithTemplate
      def initialize(exercise_correction)
        @exercise_correction = exercise_correction
      end

      def judge?
        return false if @exercise_correction.nil?
        return false if @exercise_correction.template.nil?
        template = @exercise_correction.template

        ##juge content and title+description is same
        diff     = []

        if not @exercise_correction.content == template.content
          diff << "content"
        end

        ##judge material
        m_diff   =
            ::CourseLibrary::Util::MaterialDiff.new(template,@exercise_correction).call
        diff     = diff + m_diff

        if diff.blank?
          return true
        end
        return false
      end
    end
  end
end