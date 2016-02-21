module ExerciseService
  module CourseLibrary
    class SyncWithTemplate
      def initialize(exercise)
        @exercise = exercise
      end

      def call
        return if @exercise.nil? or @exercise.homework_publication.nil? or @exercise.homework_publication.homework.nil?
        template                         =   @exercise.homework_publication.homework
        @exercise.title                  =   template.title
        @exercise.content                =   template.description
        @exercise.template_file_ids      =   template.qa_file_ids
        @exercise.template_picture_ids   =   template.picture_ids
        @exercise.save

        @exercise.solutions.each do |solution|
          solution.corrections.each do |correction|
            if not correction.template.nil?
              ExerciseCorrectionService::CourseLibrary::SyncWithTemplate.new(correction).call
            end
          end
        end
      end
    end
  end
end