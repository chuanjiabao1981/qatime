require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'


module ExerciseServiceTest
  module CourseLibraryTest
    class CreateFromPublicationTest < CustomizedTutorialServiceTest::CourseLibraryTest::PublicationTest

      test "publish" do
        course_publication    = get_course_publication
        homework_publication  = get_homework_publication(course_publication)
        assert homework_publication.valid?
        #先发布lecture
        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        #再发布homework
        exercise              = nil
        assert_difference "Exercise.count",1 do
          assert_difference 'QaFileQuoter.count',homework_publication.homework.qa_files.count do
            assert_difference 'PictureQuoter.count', homework_publication.homework.pictures.count do
              exercise  = ExerciseService::CourseLibrary::CreateFromPublication.new(homework_publication).call
            end
          end
        end
        assert exercise.valid?
      end

      test "already publish exercise" do
        course_publication    = get_course_publication
        homework_publication  = get_homework_publication(course_publication)
        assert homework_publication.valid?
        #先发布lecture
        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        #发布homework
        exercise              = ExerciseService::CourseLibrary::CreateFromPublication.new(homework_publication).call

        exercise1             = nil
        assert_difference "Exercise.count",0 do
          assert_difference 'QaFileQuoter.count',0 do
            assert_difference 'PictureQuoter.count', 0 do
              #再次发布
              exercise1  = ExerciseService::CourseLibrary::CreateFromPublication.new(homework_publication).call
            end
          end
        end
        assert exercise1 == exercise
      end
    end

  end
end
