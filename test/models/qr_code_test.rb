require 'test_helper'

class QrCodeTest < ActiveSupport::TestCase

  test 'create qr code' do
    url = 'http://google.com.hk'
    relative_path = QrCode.generate_tmp(url)
    tmp_path = Rails.root.join(relative_path)
    File.open(tmp_path) do |file|
      QrCode.create(code: file)
    end
    File.delete(tmp_path)
    assert_equal QrCode.count,2
  end
end
