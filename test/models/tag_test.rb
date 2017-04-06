require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'category of' do
    tag = tags(:高考)
    # assert_equal 19, Tag.category_of.count, "不过滤标签查询错误"
    # assert_equal 15, Tag.category_of('初三').count, "标签查询数据错误"
    # assert_equal 13, Tag.category_of('语文', '初三').count, "多个标签数据返回错误"
    # assert_equal 19, Tag.category_of('').count, "空分类数据查询错误"

  end
end
