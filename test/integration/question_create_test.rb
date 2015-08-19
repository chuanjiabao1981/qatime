require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class QuestionCreateTest < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @student1 = users(:student1)
    log_in_as(@student1)

  end
  def teardown
    logout_as(@student1)

    Capybara.use_default_driver
  end
  test "question create" do

    visit questions_path
    click_on '我要提问'
    options = {from: 'question-teachers'}
    item_text = 'teacher1'
    select_from_chosen(item_text,options)
    teacher1 = Teacher.find(users(:teacher1).id)

    assert_difference 'Question.count',1 do
      assert_difference 'teacher1.questions.count',1 do
        select '数学', from: :question_learning_plan_id
        fill_in :question_title,with: '这个长度不能少10的啊啊啊'
        # fill_in :question_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
        find('div.note-editable').set('这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321')

        click_on '新增问题'
        page.has_content? '这个长度不能少10的啊啊啊'
      end
    end
  end

  test "question edit teacher" do
    question = questions(:student1_question1)
    visit edit_question_path(question)
    options = {from: 'question-teachers',merge: true}
    item_text = 'teacher2'
    teacher1 = Teacher.find(users(:teacher1).id)
    teacher2 = Teacher.find(users(:teacher2).id)

    select_from_chosen(item_text,options)
    page.save_screenshot('screenshot.png')

    assert_difference 'Question.count',0 do
      assert_difference 'teacher1.questions.count',0 do
        assert_difference 'teacher2.questions.count',1 do

          select '数学', from: :question_learning_plan_id
          fill_in :question_title,with: '这个长度不能少10的啊啊啊'
          # fill_in :question_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
          find('div.note-editable').set('这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321')

          click_on '更新问题'
          page.has_content? '这个长度不能少10的啊啊啊'
        end
      end
    end
  end

  test "question edit learning plan" do
    question = questions(:student1_question1)
    visit edit_question_path(question)
    # select '物理', from: "科目"
    select '物理', from: :question_learning_plan_id


    options = {from: 'question-teachers',merge: true}
    item_text = 'physics_teacher1'
    select_from_chosen(item_text,options)

    page.save_screenshot('screenshot.png')
    teacher1      =  Teacher.find(users(:teacher1).id)
    teacher2      =  Teacher.find(users(:physics_teacher1).id)
    m_vip_class   =  vip_classes(:h_math_vip_class)
    h_vip_class   =  vip_classes(:h_physics_vip_class)
    assert_difference 'Question.count',0 do
      assert_difference 'teacher1.questions.count',-1 do
        assert_difference 'teacher2.questions.count',1 do
          assert_difference 'm_vip_class.questions.count',-1 do
            assert_difference 'h_vip_class.questions.count',1 do

              fill_in :question_title,with: '这个长度不能少10的啊啊啊'
              # fill_in :question_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
              find('div.note-editable').set('这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321')

              click_on '更新问题'
              page.has_content? '这个长度不能少10的啊啊啊'
            end
          end
        end
      end
    end

  end

end
