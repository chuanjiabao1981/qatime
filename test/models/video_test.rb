require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  #test "convert video name" do
  #  assert_not Video.is_converted_file? "sss-#{Video::CONVERT_POSTFIX}ssss.mp4"
  #  assert_not Video.is_converted_file? "-#{Video::CONVERT_POSTFIX}ssss.mp4"
  #  assert Video.is_converted_file? "asdfasdfasdf-#{Video::CONVERT_POSTFIX}.mp4"
  #end
  self.use_transactional_fixtures = false

  test "video convert worker" do

    a = build_a_video_with_mp4_file
    assert a.wait_convert?
    VideoConvertWorker.new.perform(a.id)
    a.reload
    assert a.convert_success?
    assert_not a.convert_name.nil?
  end

  test "video change when convert" do

    a = build_a_video_with_mp4_file
    puts a.name
    puts a.id
    puts Video.find(a.id).to_json
    Thread.new {
      sleep 10
      begin
        x = Video.find(a.id)
        File.open("#{Rails.root}/test/integration/test.mp4") do |f|
          x.name = f
        end
        x.save!
      rescue Exception=>e
        puts e
      end
    }
    VideoConvertWorker.new.perform(a.id,40)
  end

  private
  def build_a_video_with_mp4_file
    a = Video.new

    File.open("#{Rails.root}/test/integration/test.mp4") do |f|
      a.name = f
    end

    a.save!
    a.reload
    a
  end
end