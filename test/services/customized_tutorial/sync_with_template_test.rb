require 'services/customized_tutorial/template_test'

class SyncWithTemplateTest < TemplateTest
  test "course syn lecture" do
    customized_tutorial     = CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call
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
    @course_one.videos << v

    @course_one.title         = random_str
    @course_one.description   = random_str
    @course_one.save

    # assert_not customized_tutorial.is_same_with_template?
    assert_not CustomizedTutorial::SameWithTemplate.new(customized_tutorial).judge?
    assert_difference 'VideoQuoter.count',0 do
      assert_difference 'QaFileQuoter.count',1 do
        assert_difference 'PictureQuoter.count',-1 do
          # @course_one.syn_lecture_with_customized_tutorial(customized_tutorial)
          customized_tutorial.reload
          CustomizedTutorial::SyncWithTemplate.new(customized_tutorial).call
          # customized_tutorial.sync_with_template
          # assert @course_one.is_same_lecture?(customized_tutorial)
          # assert customized_tutorial.is_same_with_template?
          assert CustomizedTutorial::SameWithTemplate.new(customized_tutorial).judge?
        end
      end
    end
  end


  test "course syn homework" do
    customized_tutorial     = CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call

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
        # assert_not exercise.is_same_with_template?
        assert_not Exercise::SameWithTemplate.new(exercise).judge?
      end
    end

    assert_difference 'QaFileQuoter.count',-1 do
      assert_difference 'PictureQuoter.count',1 do
        CustomizedTutorial::SyncExercisesWithTemplate.new(customized_tutorial).call
      end
    end

    customized_tutorial.exercises.each do |exercise|
      if exercise.template.id == h.id
        # assert exercise.is_same_with_template?
        assert Exercise::SameWithTemplate.new(exercise).judge?

      end
    end
  end


  test "course syn homework after add a homework" do
    customized_tutorial = CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call
    customized_tutorial.save
    new_homework        = course_library_homeworks(:homework_three_without_course)
    @course_one.homeworks<< new_homework
    assert new_homework.reload.course_id == @course_one.id
    @course_one.reload
    assert_not customized_tutorial.exercises.count == @course_one.homeworks.count
    customized_tutorial.reload #reload 之后才能知道worker有变动
    assert_difference 'Exercise.count',1 do
      CustomizedTutorial::SyncExercisesWithTemplate.new(customized_tutorial).call
    end
    assert customized_tutorial.reload.exercises.count == @course_one.homeworks.count

    assert CustomizedTutorial::SameWithTemplate.new(customized_tutorial).judge?

  end
end
