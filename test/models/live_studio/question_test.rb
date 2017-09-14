require 'test_helper'

module LiveStudio
  class QuestionTest < ActiveSupport::TestCase
    # 学生提问
    test "student create a question" do
      @group = live_studio_groups(:schedule_published_group1)
      @teacher = @group.teacher
      @student_three = users(:student_one_with_course)

      assert_difference "@group.reload.questions.count", 1, "课程提问数量不正确" do
        assert_difference "@student_three.reload.live_studio_questions.count", 1, "学生提问数量不正确" do
          assert_difference "@teacher.reload.live_studio_questions.count", 1, "老师提问数量不正确" do
            @question = @group.questions.create(title: '提个问题试试', body: '地球为什么是圆的', user: @student_three)
          end
        end
      end

      assert @question.pending?, "提问状态不正确"
    end
  end
end
