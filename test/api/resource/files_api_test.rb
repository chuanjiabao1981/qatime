require 'test_helper'
class Qatime::FilesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @teacher_token = api_login_by_pc(@teacher, :teacher_live)
    @student = users(:student_one_with_course)
    @student_token = api_login(@student, :app)
  end

  # 我的文件
  test "teacher files list api" do
    # 全部文件
    get "/api/v1/resource/teachers/#{@teacher.id}/files", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 9, @res['data'].size

    # 文档文件
    get "/api/v1/resource/teachers/#{@teacher.id}/files", { cate: 'document' }, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 2, @res['data'].size
  end

  # 文件上传
  test "teacher upload file api" do
    file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'tran.jpg'), 'image/jpeg')
    assert_difference "@teacher.reload.files.count", 1, "文件上传失败" do
      post "/api/v1/resource/files", { file: file }, 'Remember-Token' => @teacher_token
      assert_request_success?
    end
    assert_equal 'tran.jpg', @res['data']['name'], '资源文件名称不正确'
    assert_equal 'Resource::PictureFile', @res['data']['type'], '资源文件类型不正确'
    assert_equal 105_413, @res['data']['file_size'].to_i, '资源文件大小不正确'
  end

  # 删除文件
  test "remove a file api" do
    @file = resource_files(:picture_file_one)
    assert_difference "@teacher.reload.files.count", -1, "文件删除失败" do
      delete "/api/v1/resource/files/#{@file.id}", {}, 'Remember-Token' => @teacher_token
      assert_request_success?
    end
  end

  # 文件详情
  test 'file deatil api' do
    @file = resource_files(:other_file_one)
    get "/api/v1/resource/files/#{@file.id}", {}, 'Remember-Token' => @teacher_token
    assert_request_success?
    assert_equal 2048, @res['data']['file_size'].to_i, "文件详情获取失败"
    assert_equal "http://qatime-testing.oss-cn-beijing.aliyuncs.com/upload/resource/attach/file/#{@file.attach.id}/filename.jpg", @res['data']['file_url'], "文件详情获取失败"
  end
end
