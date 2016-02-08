require 'services/customized_tutorial/template_test'

module CustomizedTutorialServiceTest
  class SameWithTemplateTest  < TemplateTest
    test "add a homework not same" do
      customized_tutorial = CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call
      customized_tutorial.save
      new_homework        = course_library_homeworks(:homework_three_without_course)
      @course_one.homeworks<< new_homework
      assert new_homework.reload.course_id == @course_one.id
      @course_one.reload
      assert_not customized_tutorial.exercises.count == @course_one.homeworks.count
      customized_tutorial.reload
      assert_not CustomizedTutorial::SameWithTemplate.new(customized_tutorial).judge?
    end
  end
end