require 'test_helper'

module LiveStudio
  class AnswerTest < ActiveSupport::TestCase
    # 老师回答问题
    test "teacher create a answer" do
      @group = live_studio_groups(:schedule_published_group1)
      @question = live_studio_tasks(:question_one)
      @teacher = @group.teacher
      @student_three = users(:student_one_with_course)

      assert_no_difference "@group.reload.questions.count", "课程提问数量不正确" do
        assert_no_difference "@student_three.reload.questions.count", "学生提问数量不正确" do
          assert_no_difference "@teacher.reload.questions.count", "老师提问数量不正确" do
            @answer = @question.build_answer(body: '因为地球有引力', user: @teacher)
            assert @answer.save
          end
        end
      end

      assert @question.reload.resolved?, "提问状态不正确"
    end

    # 老师修改回答
    test "teacher update a answer" do
      @group = live_studio_groups(:schedule_published_group1)
      @question = live_studio_tasks(:question_two)
      @answer = @question.answer
      @teacher = @group.teacher
      @student_three = users(:student_one_with_course)

      assert_no_difference "@group.reload.questions.count", "课程提问数量不正确" do
        assert_no_difference "@student_three.reload.questions.count", "学生提问数量不正确" do
          assert_no_difference "@teacher.reload.questions.count", "老师提问数量不正确" do
            assert @answer.update(body: '奶牛吃的是草，挤的是奶，这是常识')
          end
        end
      end

      assert @question.reload.resolved?, "提问状态不正确"
    end
  end
end
