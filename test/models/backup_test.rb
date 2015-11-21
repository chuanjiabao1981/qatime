require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class BackupTest < ActiveSupport::TestCase
=begin
  没有这个，无法在线程中看到case对数据库的修改
=end
  self.use_transactional_fixtures = false

  test " backup test" do


    DbBackupWorker.new.perform

  end



end