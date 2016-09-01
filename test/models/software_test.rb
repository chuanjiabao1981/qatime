require 'test_helper'

class SoftwareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'running! after set running_at' do
    software = softwares(:four)
    assert software.running_at.blank?
    software.running!
    software.reload
    assert software.running_at.present?
  end

  test 'running! after assign qr_code' do
    software = softwares(:four)
    assert software.qr_code.blank?
    software.running!
    software.reload
    assert software.qr_code.present?
  end

end
