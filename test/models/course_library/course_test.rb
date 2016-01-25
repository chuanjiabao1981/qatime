require 'test_helper'

module CourseLibrary
  class CourseTest < ActiveSupport::TestCase

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
    test "course lecture publish" do
      customized_tutorial     = @course_one.publish_lecture_to_customized_course(@customized_course1.id)
      assert customized_tutorial.valid?,customized_tutorial.errors.full_messages
      assert_difference 'CustomizedTutorial.count',1 do
        assert_difference 'VideoQuoter.count',1 do
          assert_difference 'QaFileQuoter.count',@course_one.qa_files.length do
            assert_difference 'PictureQuoter.count',@course_one.pictures.length do
              customized_tutorial.save
            end
          end
        end
      end
    end

    test "course homework publish" do
      customized_tutorial     = @course_one.publish_lecture_to_customized_course(@customized_course1.id)
      customized_tutorial.save
      @course_one.publish_homework_to_customized_tutorial(customized_tutorial)

      customized_tutorial.exercises.each do |e|
        qa_file_quoter_len  = e.template.qa_files.length
        picture_quoter_len  = e.template.pictures.length
        assert_difference 'Exercise.count',1 do
          assert_difference 'QaFileQuoter.count',qa_file_quoter_len do
            assert_difference 'PictureQuoter.count',picture_quoter_len do
              e.save
            end
          end
        end
      end
    end

    test "course publish all" do
      customized_tutorial     = @course_one.publish_all(@customized_course1.id)
      assert_difference 'CustomizedTutorial.count',1 do
        assert_difference 'Exercise.count',@homework_count do
          assert_difference 'QaFileQuoter.count',@course_total_files_count do
            assert_difference 'PictureQuoter.count', @course_total_pictures_count do
              customized_tutorial.save
            end
          end
        end
      end
    end

    test "course syn lecture" do
      customized_tutorial     = @course_one.publish_all(@customized_course1.id)
      customized_tutorial.save
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
      @course_one.video = v

      @course_one.title         = random_str
      @course_one.description   = random_str
      @course_one.save

      assert_not @course_one.is_same_lecture?(customized_tutorial)
      assert_difference 'VideoQuoter.count',0 do
        assert_difference 'QaFileQuoter.count',1 do
          assert_difference 'PictureQuoter.count',-1 do
            @course_one.syn_lecture_with_customized_tutorial(customized_tutorial)
            assert @course_one.is_same_lecture?(customized_tutorial)
          end
        end
      end
    end

    test "course syn homework" do
      customized_tutorial = @course_one.publish_all(@customized_course1.id)
      customized_tutorial.save

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

      customized_tutorial.exercises.each do |exercise|
        if exercise.template.id == h.id
          puts @course_one.is_same_homework?(exercise)
        end
      end

      assert_difference 'QaFileQuoter.count',-1 do
        assert_difference 'PictureQuoter.count',1 do
          @course_one.syn_homeworks_with_customized_tutorial(customized_tutorial)
        end
      end
    end

    test "course syn homework after add a homework" do
      customized_tutorial = @course_one.publish_all(@customized_course1.id)
      customized_tutorial.save
      new_homework        = course_library_homeworks(:homework_three_without_course)
      @course_one.homeworks<< new_homework
      assert new_homework.reload.course_id == @course_one.id
      @course_one.reload
      @course_one.syn_homeworks_with_customized_tutorial(customized_tutorial)
      assert customized_tutorial.exercises.count == @course_one.homeworks.count
    end
  end
end
