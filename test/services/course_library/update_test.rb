require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'


module CourseLibraryServiceTest
  class UpdateTest < CustomizedTutorialServiceTest::CourseLibraryTest::PublicationTest


    #普通删除一个作业，追加一个作业
    test "add a homework publication" do
      #先发布，只发布一个作业
      homeworks = @course_one.homeworks
      homework  = homeworks[0]
      course_publication = get_course_publication(homework: homework)

      customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call

      assert customized_tutorial.valid?

      e = customized_tutorial.exercises.first
      assert_difference 'Exercise.count',0 do
       assert_difference 'QaFileQuoter.count',homeworks[1].qa_files.count - homeworks[0].qa_files.count do
          assert_difference 'PictureQuoter.count', homeworks[1].pictures.count - homeworks[1].pictures.count  do
            CourseLibrary::CoursePublicationService::Update.new(course_publication,{homework_ids:[homeworks[1].id]}).call
         end
       end
      end

      #老的不在了
      assert Exercise.where(id: e.id).count == 0
    end

  end
end