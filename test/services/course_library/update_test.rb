require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'
require 'models/shared/exercise_correction/course_library/create_payed_correction_from_template'

module CourseLibraryServiceTest
  class UpdateTest < CustomizedTutorialServiceTest::CourseLibraryTest::PublicationTest


    #删除一个作业，追加一个作业
    test "remove and add" do
      #先发布，只发布一个作业
      homeworks = @course_one.homeworks
      homework  = homeworks[0]
      course_publication = get_course_publication(homework: homework)

      customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      assert customized_tutorial.valid?

      e = customized_tutorial.exercises.first
      assert_difference 'Exercise.count',0 do
       assert_difference 'QaFileQuoter.count',homeworks[1].qa_files.count - homeworks[0].qa_files.count do
          assert_difference 'PictureQuoter.count', homeworks[1].pictures.count - homeworks[0].pictures.count  do
            service_respond = CourseLibrary::CoursePublicationService::Update.new(course_publication,{homework_ids:[homeworks[1].id]}).call
            assert service_respond.success?
         end
       end
      end

      #老的不在了
      assert Exercise.where(id: e.id).count == 0
    end

    test "append" do
      #先发布，只发布一个作业
      homeworks = @course_one.homeworks
      homework  = homeworks[0]
      course_publication = get_course_publication(homework: homework)

      customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      assert customized_tutorial.valid?
      assert_difference 'Exercise.count',1 do
        assert_difference 'QaFileQuoter.count',homeworks[1].qa_files.count  do
          assert_difference 'PictureQuoter.count', homeworks[1].pictures.count  do
            service_respond = CourseLibrary::CoursePublicationService::Update.new(course_publication,{homework_ids:[homeworks[0].id,homeworks[1].id]}).call
            assert service_respond.success?
          end
        end
      end
    end

    test "remove a payed publish" do
      #先发布，只发布一个作业
      homeworks = @course_one.homeworks
      homework  = homeworks[0]
      course_publication = get_course_publication(homework: homework)

      customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      assert customized_tutorial.valid?

      #给发布的作业添加一个已经付费的批改
      exercise   = customized_tutorial.exercises.first
      QaTest::Shared::ExerciseCorrection::CourseLibrary::CreatePayedCorrectionFromTemplate.new(exercise).call



      assert_difference 'Exercise.count',0 do
        assert_difference 'QaFileQuoter.count',0 do
          assert_difference 'PictureQuoter.count',0   do
            # 这里虽然只有一个作业，
            # 但是老的不会被删除
            service_respond = CourseLibrary::CoursePublicationService::Update.new(course_publication,{homework_ids:[homeworks[1].id]}).call
            assert_not service_respond.success?

          end
        end
      end

    end


    test "remove the published lecture" do
      course_publication  = get_course_publication(publish_lecture_switch: true)
      customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      assert_difference 'Exercise.count',0 do
        assert_difference 'QaFileQuoter.count', @lecture_files_count * -1do
          assert_difference 'PictureQuoter.count',@lecture_pictures_count * -1  do
            service_respond = CourseLibrary::CoursePublicationService::Update.new(course_publication,publish_lecture_switch: false).call
            assert service_respond.success?
          end
        end
      end

    end


    test "remove the payed lecture " do
      course_publication  = get_course_publication(publish_lecture_switch: true)
      customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      customized_tutorial.set_charged
      customized_tutorial.save
      assert_difference 'QaFileQuoter.count', 0  do
        assert_difference 'PictureQuoter.count', 0  do
          service_respond= CourseLibrary::CoursePublicationService::Update.new(course_publication,publish_lecture_switch: false).call
          assert_not service_respond.success?
        end
      end

    end

  end
end