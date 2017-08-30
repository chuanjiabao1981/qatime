require 'test_helper'
class Qatime::GroupFilesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 专属课课件列表
  test "customized group files list api" do
    @group = live_studio_groups(:group_for_update_class_date)

    # 全部课件
    get "/api/v1/live_studio/groups/#{@group.id}/files", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 7, @res['data'].size

    # 图片课件
    get "/api/v1/live_studio/groups/#{@group.id}/files", { cate: 'picture' }, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 1, @res['data'].size, "课件数量不正确"
  end

  # 添加课件
  test "add files to customized group api" do
    @group = live_studio_groups(:group_for_update_class_date)
    @file = resource_files(:document_file_one)

    assert_difference "@group.reload.files.count", 1, "添加课件失败" do
      # 添加课件
      post "/api/v1/live_studio/groups/#{@group.id}/files", { file_id: @file.id }, 'Remember-Token' => @teacher_token
    end
    assert_request_success?
  end

  # 删除课件
  test "delete files from customized group api" do
    @group = live_studio_groups(:published_group1)
    @file = resource_files(:video_file_one)

    assert_difference "@group.reload.files.count", -1, "添加课件失败" do
      # 添加课件
      delete "/api/v1/live_studio/groups/#{@group.id}/files/#{@file.id}", {}, 'Remember-Token' => @teacher_token
    end
    assert_request_success?
  end
end
