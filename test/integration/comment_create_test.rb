
require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!
class CommentCreateTest < ActionDispatch::IntegrationTest

  self.use_transactional_fixtures = true

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher1            = users(:teacher1)
    log_in_as(@teacher1)

  end

  def teardown
    #@headless.destroy
    logout_as(@teacher1)
    Capybara.use_default_driver
  end

  test "comment question" do
    student1_question1  = questions(:student1_question1)

    visit questions_path
    click_on student1_question1.title
    within(".qa_question .qa_footer") do
      click_on Comment.model_name.human
    end
    assert_difference 'Comment.count',1 do
      within(".qa_question form") do
        fill_in :comment_content ,with: "15939062"
        click_on "新增#{Comment.model_name.human}"
        #等待ajax执行
        sleep 5
      end
    end
    page.has_content? "15939062"
  end

  test "homework comment" do
    homework = examinations(:homework1)
    content  = random_str
    visit homework_path(homework)

    href = "#Homework-#{homework.id}-comments"
    find(:xpath,"//a[@href=\'#{href}\']").click
    assert_difference 'Comment.count',1 do
      fill_in :comment_content, with: content
      click_on "新增#{Comment.model_name.human}"
      sleep 5
    end
    # page.save_screenshot('screenshots/screenshot.png')
    page.has_content? content
  end

  test "homework_solution_comment" do
    homework_solution = solutions(:homework_solution_one)
    content           = random_str

    visit homework_solution_path(homework_solution)
    href              = "#HomeworkSolution-#{homework_solution.id}-comments"
    find(:xpath,"//a[@href=\'#{href}\']").click
    assert_difference 'Comment.count',1 do
      fill_in :comment_content, with: content
      click_on "新增#{Comment.model_name.human}"
      sleep 5
    end
    page.has_content? content
  end

  test "homework_correction_comment" do
    homework_correction = corrections(:correction_one)
    content             = random_str
    visit homework_correction_path(homework_correction)
    href              = "#HomeworkCorrection-#{homework_correction.id}-comments"
    find(:xpath,"//a[@href=\'#{href}\']").click

    assert_difference 'Comment.count',1 do
      fill_in :comment_content, with: content
      click_on "新增#{Comment.model_name.human}"
      sleep 5
    end
    page.has_content? content

    page.save_screenshot('screenshots/screenshot.png')

  end
end
