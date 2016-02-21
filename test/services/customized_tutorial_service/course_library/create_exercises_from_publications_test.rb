require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'


module CustomizedTutorialServiceTest
  module CourseLibraryTest
    class CreateExercisesFromPublicationsTest < PublicationTest

      test "lecture and homworks" do
        course_publication = get_course_publication(publish_lecture_switch:true,include_homeworks: true)
        customized_tutorial = nil
        assert_difference 'CustomizedTutorial.count',1 do
          assert_difference 'Exercise.count',@homework_count do
            assert_difference 'QaFileQuoter.count',@course_total_files_count do
              assert_difference 'PictureQuoter.count', @course_total_pictures_count do
                customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
              end
            end
          end
        end
        assert customized_tutorial.valid?
      end


      test "lecture and homeworks already published" do
        course_publication  = get_course_publication(publish_lecture_switch:true,include_homeworks: true)
        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        assert_difference 'CustomizedTutorial.count',0 do
          assert_difference 'Exercise.count',0 do
            assert_difference 'QaFileQuoter.count',0 do
              assert_difference 'PictureQuoter.count', 0 do
                CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
              end
            end
          end
        end
      end


      test "add homework then republish" do
        course_publication  = get_course_publication(publish_lecture_switch:true,include_homeworks: true)
        customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        new_homework        = add_homework

        #把新加的homework发布到课程
        get_homework_publication(course_publication,new_homework)
        course_publication.reload

        assert_not customized_tutorial.exercises.count == @course_one.homeworks.count

        assert_difference 'Exercise.count',1 do
          CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        end
        assert customized_tutorial.reload.exercises.count == @course_one.homeworks.count

        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
      end

    end
  end
end
