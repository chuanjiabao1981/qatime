require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'
require 'models/shared/exercise_correction/course_library/create_payed_correction_from_template'


module CourseLibrary
  class CreateTest < CustomizedTutorialServiceTest::CourseLibraryTest::PublicationTest

    def setup
      super
      @customized_course2      = customized_courses(:customized_course2)
    end

    test "publish to two student" do
      assert @customized_course2.valid?,@customized_course2.errors.full_messages

      a = CoursePublicationForm.new(
                                    customized_course_ids:  [@customized_course1.id,@customized_course2.id],
                                    publish_lecture_switch: true,
                                    homework_ids: @course_one.homework_ids
                                   )
      assert_difference 'CoursePublication.count',2 do
        assert_difference 'HomeworkPublication.count',  @homework_count * 2 do
          assert_difference 'QaFileQuoter.count', @course_total_files_count * 2 do
            assert_difference 'PictureQuoter.count',@course_total_pictures_count * 2 do
              assert_difference 'CustomizedTutorial.count',2 do
                CourseLibrary::CoursePublicationService::Create.new(@course_one,a).call
              end
            end
          end
        end
      end
    end

  end
end