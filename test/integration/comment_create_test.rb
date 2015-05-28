require 'test_helper'

class CommentCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

  end

  def teardown
    #@headless.destroy
    Capybara.use_default_driver
  end

  test "comment question" do
    teacher1            = users(:teacher1)
    student1_question1  = questions(:student1_question1)
    log_in_as(teacher1)

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
end
