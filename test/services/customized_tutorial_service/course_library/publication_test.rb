require 'test_helper'

module CustomizedTutorialServiceTest
  module CourseLibraryTest
    class PublicationTest < ActiveSupport::TestCase
      def setup
        @syllabuses_one          = course_library_syllabuses(:syllabuses_one)
        @directory_one           = course_library_directories(:directory_one)
        @course_one              = course_library_courses(:course_one)
        @customized_course1      = customized_courses(:customized_course1)
        assert @syllabuses_one.valid?
        assert @course_one.valid?
        assert @directory_one.valid?
        assert @customized_course1.valid?
        assert @course_one.qa_files.length != 0
        assert @course_one.pictures.length != 0
        @homework_count                     = @course_one.homeworks.count
        @lecture_files_count                = @course_one.qa_files.count
        @lecture_pictures_count             = @course_one.pictures.count
        @course_total_files_count           = @course_one.qa_files.count
        @course_total_pictures_count        = @course_one.pictures.count
        @course_one.homeworks.each do |h|
          assert h.valid?
          assert h.qa_files.length    != 0
          @course_total_files_count    = @course_total_files_count + h.qa_files.count
          assert h.pictures.length    != 0
          @course_total_pictures_count = @course_total_pictures_count + h.pictures.count
        end
      end



      def get_course_publication(options={})
        course_publication = CourseLibrary::CoursePublication.new(course: @course_one,customized_course: @customized_course1)
        if options[:publish_lecture_switch]
          course_publication.publish_lecture_switch = true
        end
        if options[:include_homeworks]
          @course_one.homeworks.each do |h|
            get_homework_publication(course_publication,h)
          end
        end
        if options[:homework]
          get_homework_publication(course_publication,options[:homework])
        end
        course_publication.save!
        course_publication
      end

      def get_homework_publication(course_publication,homework=nil)
        if homework.nil?
          h =  @course_one.homeworks.first
        else
          h = homework
        end
        homework_publication  = CourseLibrary::HomeworkPublication.new(course_publication: course_publication,homework:h)
        homework_publication.save!
        homework_publication
      end

      def change_lecture_media
        #减少一个图片
        assert_difference 'PictureQuoter.count',-1 do
          x = @course_one.picture_ids
          x.shift
          @course_one.picture_ids = x
        end
        #增加一个文件
        f = qa_files(:qa_file_6_for_course_library_course_sync_test)
        assert_difference 'QaFileQuoter.count',1 do
          x = @course_one.qa_file_ids
          x.append(f.id)
          @course_one.qa_file_ids = x
        end
        v = videos(:video_template_for_course_syn)
        #修改video引用
        @course_one.videos << v

        @course_one.save
      end

      def change_lecture_text
        @course_one.title         = random_str
        @course_one.description   = random_str
      end

      def change_lecture_all
        change_lecture_media
        change_lecture_text
      end

      def add_homework
        new_homework        = course_library_homeworks(:homework_three_without_course)
        @course_one.homeworks<< new_homework
        assert new_homework.reload.course_id == @course_one.id
        @course_one.reload
        new_homework
      end

      def change_homework
        h = @course_one.homeworks.first
        #增加一个图片
        assert_difference 'PictureQuoter.count',1 do
          p = pictures(:picture_7_for_course_library_course_sync)
          x = h.picture_ids
          x.append(p.id)
          h.picture_ids = x
        end
        #删除一个文件
        assert_difference 'QaFileQuoter.count',-1 do
          x = h.qa_file_ids
          x.shift
          h.qa_file_ids = x
        end
        h
      end
    end
  end
end
