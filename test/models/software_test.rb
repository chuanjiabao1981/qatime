require 'test_helper'

class SoftwareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'running! after set running_at' do
    software = softwares(:four)
    assert software.published_at.blank?
    software.published!
    software.reload
    assert software.published_at.present?
  end

  test 'running! after assign qr_code' do
    software = softwares(:four)
    assert software.qr_code.blank?
    software.published!
    software.reload
    assert software.qr_code.present?
  end

end
