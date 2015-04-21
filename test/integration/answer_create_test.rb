require 'test_helper'

class AnswerCreateTest < ActionDispatch::IntegrationTest
  test "answer question" do
    headless = Headless.new
    headless.start
    #at_exit do
    #  headless.destroy
    #end
    Capybara.current_driver = :selenium_chrome

    teacher1            = users(:teacher1)
    student1_question1  = questions(:student1_question1)
    log_in_as(teacher1)

    visit questions_path
    #print page.html
    click_on student1_question1.title
    #print page.html

    assert_difference 'Answer.count',1 do
      fill_in :answer_content,with: '答案是这个样子的，确实是这个样子的字符0987654321009876543210'
      click_on '提交讲解'
    end


  end
end
