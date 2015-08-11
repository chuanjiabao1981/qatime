require 'test_helper'

class VideoTest < ActiveSupport::TestCase
=begin
  没有这个，无法在线程中看到case对数据库的修改
=end
  self.use_transactional_fixtures = false

  test "video convert worker" do

    a = build_a_video_with_mp4_file_in_queue
    assert a.in_queue?
    VideoConvertWorker.new.perform(a.id)
    a.reload
    assert a.convert_success?
    assert_not a.convert_name.nil?
  end

=begin
  这个case 用于测试
=end

  test "video change when convert" do

    a =    build_a_video_with_mp4_file_in_queue


    Thread.new {
      sleep 5
      # 在开始converting后进行 修改video
      begin
        x = Video.find(a.id)
        File.open("#{Rails.root}/test/integration/test.mp4") do |f|
          x.name = f
        end
        assert x.converting?
        x.state = :not_convert
        x.save!
      rescue Exception=>e
        puts e
      end
    }
    assert_raises(VideoChangedWhenConvertingException) {
      VideoConvertWorker.new.perform(a.id,10)
    }
    x = Video.find(a.id)
    assert x.not_convert?
  end

  private
  def build_a_video_with_mp4_file_in_queue
    a = Video.new
    a.author = users(:teacher1)
    File.open("#{Rails.root}/test/integration/test.mp4") do |f|
      a.name = f
    end
    a.state = :in_queue
    a.save!
    a.reload
    a
  end
end