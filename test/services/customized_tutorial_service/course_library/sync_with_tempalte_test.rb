require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'


module CustomizedTutorialServiceTest
  module CourseLibraryTest
    class SyncWithTemplate < PublicationTest

      def setup
        super
        @__course_publication  =
            ::CourseLibrary::CoursePublicationService::Util::PublicationTotal.new(@course_one,@customized_course1,publish_lecture_switch: true).call

        @__customized_tutorial =
            CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(@__course_publication).call
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(@__customized_tutorial).judge?

      end
      test "change lecture and sync" do
        change_lecture_all
        ##改变后不同了
        assert_not CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(@__customized_tutorial).judge?
        ##同步
        assert_difference 'VideoQuoter.count',0 do
          assert_difference 'QaFileQuoter.count',1 do
            assert_difference 'PictureQuoter.count',-1 do
              CustomizedTutorialService::CourseLibrary::SyncWithTemplate.new(@__customized_tutorial).call
            end
          end
        end
        ##同步后相同了
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(@__customized_tutorial).judge?
      end

      test "change exercises and sync" do
        h = change_homework
        @__customized_tutorial.exercises.each do |exercise|
          if exercise.homework_publication.homework_id == h.id
            assert_not ExerciseService::CourseLibrary::SameWithTemplate.new(exercise).judge?
          end
        end
        #作业变了，课程也有diff
        @__customized_tutorial.reload
        assert_not CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(@__customized_tutorial).judge?


        assert_difference 'QaFileQuoter.count',-1 do
          assert_difference 'PictureQuoter.count',1 do
            CustomizedTutorialService::CourseLibrary::SyncExercisesWithTemplate.new(@__customized_tutorial).call
          end
        end

        @__customized_tutorial.exercises.each do |exercise|
          if exercise.homework_publication.homework_id == h.id
            assert ExerciseService::CourseLibrary::SameWithTemplate.new(exercise).judge?
          end
        end

        ##同步后相同了
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(@__customized_tutorial).judge?
      end
    end
  end
end
