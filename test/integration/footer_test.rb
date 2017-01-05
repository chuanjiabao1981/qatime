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
    assert find('.link-phonenum').has_content?('400-838-8010')
    assert page.has_content?('769051099 韩老师')
    assert page.has_content?('819178240 关老师')
    assert page.has_content?('阳泉市开发区大连路36号远东大厦 809')
    assert page.has_content?('Copyright © 2013-2015 QaTime')
    assert page.has_content?('京ICP备12031445号-3')
  end

end
