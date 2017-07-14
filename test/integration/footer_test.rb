require 'test_helper'

class  FooterTest < ActionDispatch::IntegrationTest

  def setup
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "home page data" do
    visit home_path
    find('.fixed-phone').hover
    assert page.has_content?('400-838-8010')
    find('.fixed-weixin').hover
    assert page.has_content?('微信公众号:答疑时间')

    assert page.has_link?('微信公众号')
    assert page.has_link?('关于我们')
    assert page.has_link?('联系我们')
    assert page.has_link?('帮助中心')
    assert page.has_link?('程序下载')

    assert page.has_content?('智造互联乐享教育—答疑时间与您共筑教育梦想')
  end

end
