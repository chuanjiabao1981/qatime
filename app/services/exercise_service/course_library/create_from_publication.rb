module ExerciseService
  module CourseLibrary
    class CreateFromPublication

      def initialize(homework_publication)
        @homework_publication = homework_publication
      end

      def call
        customized_tutorial   = @homework_publication.course_publication.customized_tutorial

        if customized_tutorial.nil?
          raise "can't create from publication which customized tutorial is not publish"
        end
        exercise_template     = @homework_publication.homework

        #如果customized_tutorial中已经了有一个exercise使用此publication， 则直接返回
        already_exercises =  Exercise.where(customized_tutorial_id: customized_tutorial.id,
                                            homework_publication_id: @homework_publication.id)

        if not already_exercises.blank?
          return already_exercises.first
        end

        #没有则创建之
        exercise = customized_tutorial.exercises.build(customized_course_id: customized_tutorial.customized_course_id,
                                                        teacher_id:  exercise_template.course.author_id,
                                                        last_operator_id: exercise_template.course.author_id,
                                                        title: exercise_template.title,
                                                        content: exercise_template.description,
                                                        student_id: customized_tutorial.customized_course.student.id
        )
        exercise.homework_publication   = @homework_publication
        exercise.template_file_ids      = exercise_template.qa_file_ids
        exercise.template_picture_ids   = exercise_template.picture_ids
        exercise.save!
        exercise
      end
    end
  end
end
