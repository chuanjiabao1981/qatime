require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'


module CustomizedTutorialServiceTest
  module CourseLibraryTest
    class CreateFromPublicationTest < PublicationTest

      test "test switch off" do

        course_publication = get_course_publication
        assert_not  course_publication.publish_lecture_switch
        customized_tutorial = nil
        assert_difference 'CustomizedTutorial.count',1 do
          assert_difference 'Exercise.count',0 do
            assert_difference 'QaFileQuoter.count',0 do
              assert_difference 'PictureQuoter.count', 0 do
                customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
              end
            end
          end
        end

        assert customized_tutorial.valid?
      end

      test "test switch on" do
        course_publication = get_course_publication(publish_lecture_switch: true)
        customized_tutorial = nil
        assert_difference 'CustomizedTutorial.count',1 do
          assert_difference 'Exercise.count',0 do
            assert_difference 'QaFileQuoter.count',@lecture_files_count do
              assert_difference 'PictureQuoter.count', @lecture_pictures_count do
                customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
              end
            end
          end
        end
        assert customized_tutorial.valid?
      end


      test "already have cusetomized_tutorial" do
        course_publication    = get_course_publication(publish_lecture_switch: true)
        customized_tutorial   = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        customized_tutorial2  = nil
        assert_difference 'CustomizedTutorial.count',0 do
          assert_difference 'Exercise.count',0 do
            assert_difference 'QaFileQuoter.count',0 do
              assert_difference 'PictureQuoter.count', 0 do
                customized_tutorial2 = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
              end
            end
          end
        end
        assert customized_tutorial2 == customized_tutorial
      end
    end
  end
end
