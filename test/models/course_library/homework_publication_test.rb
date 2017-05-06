require 'test_helper'
require 'models/shared/exercise_correction/course_library/create_payed_correction_from_template'

module CourseLibrary
  class HomeworkPublicationTest < ActiveSupport::TestCase


    test "validate" do
      homework_publication = course_library_homework_publications(:homework_publication_for_homework_one)
      assert homework_publication.valid?
    end

    test "uniquenes" do

      course_publication    = course_library_course_publications(:course_publication_for_course_one)
      homework_one          = course_library_homeworks(:homework_one)
      homework_publication  = HomeworkPublication.new(course_publication: course_publication,homework: homework_one)

      #已经发布所以not valid
      assert_not homework_publication.valid?

      homework_two          = course_library_homeworks(:homework_two)
      homework_publication  = HomeworkPublication.new(course_publication: course_publication,homework: homework_two)
      assert homework_publication.valid?
    end


    test "destroy success" do
      course_one           = course_library_courses(:course_one)
      customized_course    = customized_courses(:customized_course1)
      course_publication   = CoursePublicationService::Util::PublicationTotal.new(course_one,customized_course).call

      CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      homework_publication = course_publication.homework_publications.first
      assert_difference "Exercise.count",-1 do
        assert_difference "CourseLibrary::HomeworkPublication.count",-1 do
          assert homework_publication.destroy
        end
      end
    end


    test "destroy fail because already fee" do
      course_one           = course_library_courses(:course_one)
      customized_course    = customized_courses(:customized_course1)
      course_publication   = CoursePublicationService::Util::PublicationTotal.new(course_one,customized_course).call

      customized_tutorial  = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      homework_publication = course_publication.homework_publications.first
      exercise             = homework_publication.exercise

      correction = QaTest::Shared::ExerciseCorrection::CourseLibrary::CreatePayedCorrectionFromTemplate.new(exercise).call

      homework_publication.reload
      assert_difference "Exercise.count", 0 do
        assert_difference "CourseLibrary::HomeworkPublication.count", 0 do
          homework_publication.destroy
        end
      end
    end
  end
end
