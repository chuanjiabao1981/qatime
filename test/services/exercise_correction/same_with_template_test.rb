require 'test_helper'
require 'services/exercise_correction/template_test'


module ExerciseCorrectionServiceTest
  class SameWithTemplateTest < TemplateTest
    test "video not same" do
      ec = ExerciseCorrection::BuildFromTemplate.new(@student_solution,@correction_template.id).call
      assert ec.valid?,ec.errors.full_messages

      assert ExerciseCorrection::SameWithTemplate.new(ec).judge?
      ec.save

      #修改模板的视频
      video             = Video.new
      video.author      = @course_one.author
      assert video.valid?,video.errors.full_messages
      video.save

      @correction_template.videos <<  video

      # 判断应该不同了
      assert_not ExerciseCorrection::SameWithTemplate.new(ec).judge?
      assert_not CustomizedTutorial::SameWithTemplate.new(@customized_tutorial).judge?

      # 同步
      CustomizedTutorial::SyncExercisesWithTemplate.new(@customized_tutorial).call

      ec.reload

      # 已经相同了
      assert ExerciseCorrection::SameWithTemplate.new(ec).judge?
      assert CustomizedTutorial::SameWithTemplate.new(@customized_tutorial).judge?
    end

    test "title not same" do
      ec = ExerciseCorrection::BuildFromTemplate.new(@student_solution,@correction_template.id).call
      assert ec.valid?,ec.errors.full_messages

      assert ExerciseCorrection::SameWithTemplate.new(ec).judge?
      ec.save

      #修改title
      @correction_template.title  =  random_str
      @correction_template.save

      # 判断应该不同了
      ec.reload
      assert_not ExerciseCorrection::SameWithTemplate.new(ec).judge?
      assert_not CustomizedTutorial::SameWithTemplate.new(@customized_tutorial).judge?


      # 同步
      CustomizedTutorial::SyncExercisesWithTemplate.new(@customized_tutorial).call
      ec.reload

      # 已经相同了
      assert ExerciseCorrection::SameWithTemplate.new(ec).judge?
      assert CustomizedTutorial::SameWithTemplate.new(@customized_tutorial).judge?

    end
  end


end