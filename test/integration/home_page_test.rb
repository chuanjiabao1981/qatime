
require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!
class CommentCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "home page" do
    visit root_path
    assert_equal 8, page.all("#choiceness .item-handpick li").size, "精选内容显示数量显示不正确"
    assert_equal 6, page.all("#choiceness .item-handpick li.default").size, "默认精选内容显示数量显示不正确"
  end
end
