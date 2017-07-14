require 'test_helper'

class QaFaqTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @admin = users(:admin)
    new_log_in_as(@admin)
  end

  def teardown
    new_logout_as(@admin)
    Capybara.use_default_driver
  end

  test 'test link' do
    visit qa_faqs_path
    assert page.has_content?(QaFaq.faq.last.title)
    assert page.has_link? '平台使用流程'
    assert page.has_link? '老师使用指引'
    assert page.has_link? '学生使用指引'
    assert page.has_link? '常见问题'
    assert page.has_link? '增加常见问题'
    assert page.has_link? '用户协议'
    assert page.has_link? '充值和提现说明'
    assert page.has_link? '了解答疑时间'
  end

  test 'create qa faq' do
    visit qa_faqs_path
    click_on '增加常见问题', match: :first

    select '常见问题', from: :qa_faq_show_type
    select '通用', from: :qa_faq_qa_faq_type
    fill_in :qa_faq_title, with: '测试问题1'
    find('div[contenteditable]').set('test description')
    assert_difference "QaFaq.faq.count", 1 do
      click_on '新增常见问题'
    end
  end

  test 'create static page' do
    visit qa_faqs_path
    click_on '增加常见问题', match: :first

    select '静态页面', from: :qa_faq_show_type
    select '通用', from: :qa_faq_qa_faq_type
    fill_in :qa_faq_position, with: '1'
    fill_in :qa_faq_title, with: '静态页面1'
    find('div[contenteditable]').set('静态页面1 description')
    assert_difference "QaFaq.static_page.count", 1 do
      click_on '新增常见问题'
    end
  end
end
