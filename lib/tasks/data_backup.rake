require_relative '../../app/workers/db_backup_worker'
namespace :data_backup do
  desc 'database back up use gem backup'
  task :db => :environment do
    DbBackupWorker.perform_async
  end
end