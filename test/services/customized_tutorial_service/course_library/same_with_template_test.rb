require 'test_helper'

require 'services/customized_tutorial_service/course_library/publication_test'


module CustomizedTutorialServiceTest
  module CourseLibraryTest
    class SameWithTemplate < PublicationTest
      test "add a homework but not publish so is same" do
        course_publication = ::CourseLibrary::CoursePublicationService::Util::PublicationTotal.new(@course_one,@customized_course1).call
        customized_tutorial = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
        add_homework
        ##和模板相比作业少了一个
        assert_not customized_tutorial.exercises.count == @course_one.homeworks.count
        customized_tutorial.reload
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
      end

      test "change media so not same" do
        course_publication =
            ::CourseLibrary::CoursePublicationService::Util::PublicationTotal.new(@course_one,@customized_course1,publish_lecture_switch: true).call
        customized_tutorial =
            CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
        change_lecture_media
        customized_tutorial.reload
        assert_not CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
      end

      test "chage media but switch is off so is same" do
        course_publication =
            ::CourseLibrary::CoursePublicationService::Util::PublicationTotal.new(@course_one,@customized_course1,publish_lecture_switch: false).call
        customized_tutorial =
            CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
        change_lecture_media
        customized_tutorial.reload
        assert CustomizedTutorialService::CourseLibrary::SameWithTemplate.new(customized_tutorial).judge?
      end
    end


  end
end
