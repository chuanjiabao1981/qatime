require_relative '../../app/workers/db_backup_worker'
namespace :data_backup do
  desc 'database back up use gem backup'
  task :db => :environment do
    puts "begin backup db........"
    DbBackupWorker.perform_async
    puts "end backup db......."
  end
end