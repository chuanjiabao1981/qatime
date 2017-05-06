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

    assert page.has_link?('帮助中心')
    assert page.has_link?('程序下载')

    assert page.has_content?('名师')
    assert page.has_content?('多种学习模式')
    assert page.has_content?('直播+互动+视频')
    assert page.has_content?('量身定制')
    assert page.has_content?('Web/App/直播器')
    assert page.has_content?('工作站模式')
  end

end
