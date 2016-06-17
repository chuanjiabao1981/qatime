require 'test_helper'
require 'models/shared/utils/qa_test_factory'

class CorrectionCreateFromTemplateTest  < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = false

  def setup
      @customized_course        = customized_courses(:customized_course1)
      @course                   = course_library_courses(:course_one)
      @student                  = users(:student1)

      # @customized_tutorial      = @course.publish_all(@customized_course.id)
      course_publication        = CourseLibrary::CoursePublicationService::Util::PublicationTotal.new(@course,@customized_course,publish_lecture_switch:true).call
      @customized_tutorial      = CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
      @correction_template      = course_library_solutions(:solution_two_for_homework_one)
      @exercise_template        = @correction_template.homework

      @customized_tutorial.exercises.each do |e|
          if e.template.id == @exercise_template.id
            @exercise_from_template =  e
            break
          end
        end
      @headless = Headless.new
      @headless.start
      Capybara.current_driver           =  :selenium_chrome

      @teacher                          =  users(:teacher1)
      log_in_as(@teacher)


    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "create" do
      @exercise_solution        = QaTestFactory::QaSolutionFactory.build(@exercise_from_template)
      @exercise_solution.save
      homework_solution_one     = course_library_solutions(:solution_two_for_homework_one)
      visit exercise_solution_path(@exercise_solution)
      assert_not page.has_css?("div#xxxx") #视频
      click_on I18n.t("view.exercise_correction.use_template")
      choose(homework_solution_one.title)
      sleep(4)
      assert page.has_css?("div#xxxx") #视频
      click_on "新增#{ExerciseCorrection.model_name.human}"

      assert page.has_content?(homework_solution_one.description)
      page.save_screenshot('screenshots/screenshot.png')


    end
end
